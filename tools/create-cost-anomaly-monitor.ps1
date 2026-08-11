<#
Creates the governed AWS Cost Anomaly Detection resources used by chapter 10.

The script is idempotent: an existing monitor, SNS topic, or matching
subscription is reused. It creates no email, Slack, or chat subscription;
those destinations require an approved endpoint and are configured separately.
#>
[CmdletBinding()]
param(
    [string]$Region = 'ap-southeast-2',
    [string]$MonitorName = 'FinOpsProject-ServiceMonitor',
    [string]$TopicName = 'finops-project-cost-anomalies',
    [string]$SubscriptionName = 'finops-project-cost-anomaly-subscription',
    [double]$ManagedCostImpactThresholdUsd = 10,
    [ValidateSet('IMMEDIATE', 'DAILY', 'WEEKLY')]
    [string]$Frequency = 'IMMEDIATE'
)

$ErrorActionPreference = 'Stop'

function Invoke-AwsJson {
    param([string[]]$Arguments)

    $result = & aws @Arguments --output json
    if ($LASTEXITCODE -ne 0) {
        throw "AWS CLI command failed: aws $($Arguments -join ' ')"
    }
    return $result | ConvertFrom-Json
}

$identity = Invoke-AwsJson @('sts', 'get-caller-identity')
$accountId = $identity.Account

$topicList = Invoke-AwsJson @('sns', 'list-topics', '--region', $Region)
$topic = @($topicList.Topics | Where-Object { $_.TopicArn -like "*:$TopicName" }) | Select-Object -First 1
if (-not $topic) {
    $topic = Invoke-AwsJson @(
        'sns', 'create-topic',
        '--region', $Region,
        '--name', $TopicName,
        '--tags', 'Key=Project,Value=CUDOSWS', 'Key=Purpose,Value=CostAnomalyDelivery'
    )
    $topic = [pscustomobject]@{ TopicArn = $topic.TopicArn }
}
$topicArn = $topic.TopicArn

# Keep standard account-owner administration and allow Cost Anomaly Detection
# to publish alerts. The Flow/monitor has no authority to alter workloads.
$topicPolicy = @{
    Version = '2012-10-17'
    Id = "$topicArn/Default"
    Statement = @(
        @{
            Sid = '__default_statement_ID'
            Effect = 'Allow'
            Principal = @{ AWS = '*' }
            Action = @(
                'SNS:GetTopicAttributes', 'SNS:SetTopicAttributes', 'SNS:AddPermission',
                'SNS:RemovePermission', 'SNS:DeleteTopic', 'SNS:Subscribe',
                'SNS:ListSubscriptionsByTopic', 'SNS:Publish', 'SNS:Receive'
            )
            Resource = $topicArn
            Condition = @{ StringEquals = @{ 'AWS:SourceOwner' = $accountId } }
        },
        @{
            Sid = 'AllowCostAnomalyDetectionPublish'
            Effect = 'Allow'
            Principal = @{ Service = 'costalerts.amazonaws.com' }
            Action = 'SNS:Publish'
            Resource = $topicArn
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

& aws sns set-topic-attributes `
    --region $Region `
    --topic-arn $topicArn `
    --attribute-name Policy `
    --attribute-value $topicPolicy
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to set the SNS topic policy for Cost Anomaly Detection.'
}

$monitorList = Invoke-AwsJson @('ce', 'get-anomaly-monitors', '--region', $Region)
$monitor = @($monitorList.AnomalyMonitors | Where-Object { $_.MonitorName -eq $MonitorName }) | Select-Object -First 1
if (-not $monitor) {
    $monitor = Invoke-AwsJson @(
        'ce', 'create-anomaly-monitor',
        '--region', $Region,
        '--anomaly-monitor', "MonitorName=$MonitorName,MonitorType=DIMENSIONAL,MonitorDimension=SERVICE",
        '--resource-tags', 'Key=Project,Value=CUDOSWS', 'Key=Purpose,Value=CostAnomalyDetection'
    )
    $monitor = [pscustomobject]@{ MonitorArn = $monitor.MonitorArn; MonitorName = $MonitorName }
}
$monitorArn = $monitor.MonitorArn

$subscriptionList = Invoke-AwsJson @('ce', 'get-anomaly-subscriptions', '--region', $Region)
$subscription = @($subscriptionList.AnomalySubscriptions | Where-Object { $_.SubscriptionName -eq $SubscriptionName }) | Select-Object -First 1
if (-not $subscription) {
    $subscriptionInput = @{
        AnomalySubscription = @{
            MonitorArnList = @($monitorArn)
            Subscribers = @(
                @{ Address = $topicArn; Type = 'SNS' }
            )
            Threshold = $ManagedCostImpactThresholdUsd
            Frequency = $Frequency
            SubscriptionName = $SubscriptionName
        }
        ResourceTags = @(
            @{ Key = 'Project'; Value = 'CUDOSWS' },
            @{ Key = 'Purpose'; Value = 'CostAnomalyDelivery' }
        )
    } | ConvertTo-Json -Depth 10 -Compress

    $subscription = Invoke-AwsJson @(
        'ce', 'create-anomaly-subscription',
        '--region', $Region,
        '--cli-input-json', $subscriptionInput
    )
    $subscription = [pscustomobject]@{ SubscriptionArn = $subscription.SubscriptionArn; SubscriptionName = $SubscriptionName }
}

[pscustomobject]@{
    Region = $Region
    MonitorName = $MonitorName
    MonitorType = 'SERVICE'
    ManagedCostImpactThresholdUsd = $ManagedCostImpactThresholdUsd
    Frequency = $Frequency
    SnsTopicName = $TopicName
    SubscriptionName = $SubscriptionName
    DeliveryEndpointConfigured = $false
    DeterministicMaterialityRule = 'percentage increase > 20% AND absolute increase > USD 10'
} | Format-List
