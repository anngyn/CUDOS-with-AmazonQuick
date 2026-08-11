$ErrorActionPreference = 'Stop'

$region = 'ap-southeast-2'
$accountId = aws sts get-caller-identity --region $region --query Account --output text
$topicId = 'finops-cudos-demo-q-topic'
$dataSetArn = "arn:aws:quicksight:$region`:$accountId`:dataset/cudos-dashboard-demo-mock"

if ((aws quicksight list-topics --aws-account-id $accountId --region $region --query "TopicsSummaries[?TopicId=='$topicId'].TopicId" --output text) -eq $topicId) {
    Write-Output "Topic $topicId already exists."
    exit 0
}

function New-TopicColumn {
    param(
        [string]$Name,
        [string]$FriendlyName,
        [string]$Description,
        [string]$Role,
        [string[]]$Synonyms = @(),
        [bool]$Include = $true
    )

    [pscustomobject]@{
        ColumnName = $Name
        ColumnFriendlyName = $FriendlyName
        ColumnDescription = $Description
        ColumnSynonyms = $Synonyms
        ColumnDataRole = $Role
        IsIncludedInTopic = $Include
        DisableIndexing = $false
    }
}

$topic = [pscustomobject]@{
    Name = 'FinOps CUDOS Demo Q&A [Synthetic]'
    Description = 'Grounded Q&A topic for the synthetic July 2026 FinOps CUDOS-style demonstration in Sydney.'
    UserExperienceVersion = 'NEW_READER_EXPERIENCE'
    DataSets = @(
        [pscustomobject]@{
            DatasetArn = $dataSetArn
            DatasetName = 'CUDOS Dashboard Demo [Synthetic]'
            DatasetDescription = 'Synthetic Direct Query daily cloud cost data for July 2026 in ap-southeast-2.'
            DataAggregation = [pscustomobject]@{
                DatasetRowDateGranularity = 'DAY'
                DefaultDateColumnName = 'usage_date'
            }
            Columns = @(
                (New-TopicColumn 'usage_date' 'Usage Date' 'Daily usage date for July 2026.' 'DIMENSION' @('date','day','reporting day')),
                (New-TopicColumn 'billing_period' 'Billing Period' 'Billing month associated with the synthetic cost.' 'DIMENSION' @('month','billing month')),
                (New-TopicColumn 'service' 'AWS Service' 'AWS service that incurred the cost.' 'DIMENSION' @('service','AWS product')),
                (New-TopicColumn 'owner' 'Cost Owner' 'Team accountable for the workload cost.' 'DIMENSION' @('owner','team','cost owner')),
                (New-TopicColumn 'account_name' 'Account Name' 'Synthetic workload account name.' 'DIMENSION' @('account','workload account')),
                (New-TopicColumn 'environment' 'Environment' 'Workload environment such as production, staging, or shared.' 'DIMENSION' @('environment','stage')),
                (New-TopicColumn 'region' 'AWS Region' 'AWS Region of the synthetic cost data.' 'DIMENSION' @('region','Sydney','ap-southeast-2')),
                (New-TopicColumn 'service_category' 'Service Category' 'High-level group for the AWS service.' 'DIMENSION' @('category','cost category')),
                (New-TopicColumn 'workload_name' 'Workload Name' 'Named synthetic workload associated with the cost.' 'DIMENSION' @('workload','application')),
                (New-TopicColumn 'net_unblended_cost' 'Net Unblended Cost' 'Synthetic net unblended cloud cost in USD. This is the only financial metric for the topic.' 'MEASURE' @('cost','spend','net cost','cloud cost'))
            )
        }
    )
}

$topicJson = $topic | ConvertTo-Json -Depth 20 -Compress
$instructions = [pscustomobject]@{
    CustomInstructionsString = 'Use only the linked FinOps dataset. State July 2026, net unblended cost, and ap-southeast-2 when reporting spend. Do not invent financial values or causes. Separate observed drivers from hypotheses. Recommend investigation only and never imply remediation approval.'
} | ConvertTo-Json -Depth 5 -Compress

aws quicksight create-topic --aws-account-id $accountId --topic-id $topicId --topic $topicJson --custom-instructions $instructions --region $region --output json
