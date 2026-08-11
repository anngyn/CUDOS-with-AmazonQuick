<#
Produces a sanitized read-only audit of the deployed FinOps analytical boundary.
It intentionally omits account IDs, ARNs, bucket names, and policy resources.
#>
[CmdletBinding()]
param(
    [string]$Region = 'ap-southeast-2',
    [string]$QuickSightDatasourceRoleName = 'CidCmdQuickSightDataSourceRole'
)

$ErrorActionPreference = 'Stop'

function Invoke-AwsJson {
    param([string[]]$Arguments)

    $result = & aws @Arguments --output json
    if ($LASTEXITCODE -ne 0) {
        throw "AWS CLI command failed: aws $($Arguments -join ' ')"
    }
    $result | ConvertFrom-Json
}

$accountId = (Invoke-AwsJson @('sts', 'get-caller-identity')).Account
$dataExportsBucket = "cid-$accountId-data-exports"
$athenaResultsBucket = "finops-workshop-athena-results-$accountId-$Region"

$dataExportsEncryption = Invoke-AwsJson @('s3api', 'get-bucket-encryption', '--bucket', $dataExportsBucket)
$dataExportsBlock = Invoke-AwsJson @('s3api', 'get-public-access-block', '--bucket', $dataExportsBucket)
$athenaResultsEncryption = Invoke-AwsJson @('s3api', 'get-bucket-encryption', '--bucket', $athenaResultsBucket)
$athenaResultsBlock = Invoke-AwsJson @('s3api', 'get-public-access-block', '--bucket', $athenaResultsBucket)
$workgroup = Invoke-AwsJson @('athena', 'get-work-group', '--work-group', 'primary', '--region', $Region)
$role = Invoke-AwsJson @('iam', 'get-role', '--role-name', $QuickSightDatasourceRoleName)
$attachedPolicies = (Invoke-AwsJson @('iam', 'list-attached-role-policies', '--role-name', $QuickSightDatasourceRoleName)).AttachedPolicies
$inlinePolicyNames = (Invoke-AwsJson @('iam', 'list-role-policies', '--role-name', $QuickSightDatasourceRoleName)).PolicyNames

$policyDocuments = @()
foreach ($attachedPolicy in $attachedPolicies) {
    $policy = Invoke-AwsJson @('iam', 'get-policy', '--policy-arn', $attachedPolicy.PolicyArn)
    $version = Invoke-AwsJson @('iam', 'get-policy-version', '--policy-arn', $attachedPolicy.PolicyArn, '--version-id', $policy.Policy.DefaultVersionId)
    $policyDocuments += $version.PolicyVersion.Document
}
foreach ($inlinePolicyName in $inlinePolicyNames) {
    $policyDocuments += (Invoke-AwsJson @('iam', 'get-role-policy', '--role-name', $QuickSightDatasourceRoleName, '--policy-name', $inlinePolicyName)).PolicyDocument
}

$allActions = @()
foreach ($policyDocument in $policyDocuments) {
    foreach ($statement in @($policyDocument.Statement)) {
        foreach ($action in @($statement.Action)) { $allActions += [string]$action }
    }
}

$reviewedForbiddenActions = @('ec2:TerminateInstances', 'rds:DeleteDBInstance', 'iam:CreateUser')
$forbiddenMatches = foreach ($action in $reviewedForbiddenActions) {
    if ($allActions | Where-Object { $_ -eq $action -or $_ -eq '*' -or $_ -like ($action.Split(':')[0] + ':*') }) { $action }
}

$trustServices = foreach ($statement in @($role.Role.AssumeRolePolicyDocument.Statement)) {
    if ($statement.Principal.Service) { @($statement.Principal.Service) }
}

[pscustomobject]@{
    Region = $Region
    DataExports = [pscustomobject]@{
        DefaultEncryption = $dataExportsEncryption.ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm
        PublicAccessBlockEnabled = [bool]($dataExportsBlock.PublicAccessBlockConfiguration.BlockPublicAcls -and $dataExportsBlock.PublicAccessBlockConfiguration.IgnorePublicAcls -and $dataExportsBlock.PublicAccessBlockConfiguration.BlockPublicPolicy -and $dataExportsBlock.PublicAccessBlockConfiguration.RestrictPublicBuckets)
    }
    AthenaResults = [pscustomobject]@{
        DefaultEncryption = $athenaResultsEncryption.ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm
        PublicAccessBlockEnabled = [bool]($athenaResultsBlock.PublicAccessBlockConfiguration.BlockPublicAcls -and $athenaResultsBlock.PublicAccessBlockConfiguration.IgnorePublicAcls -and $athenaResultsBlock.PublicAccessBlockConfiguration.BlockPublicPolicy -and $athenaResultsBlock.PublicAccessBlockConfiguration.RestrictPublicBuckets)
    }
    AthenaPrimaryWorkgroup = [pscustomobject]@{
        EnforceWorkGroupConfiguration = $workgroup.WorkGroup.Configuration.EnforceWorkGroupConfiguration
        QueryResultEncryption = $workgroup.WorkGroup.Configuration.ResultConfiguration.EncryptionConfiguration.EncryptionOption
    }
    QuickSightDatasourceRole = [pscustomobject]@{
        TrustedServices = $trustServices
        AttachedPolicyCount = @($attachedPolicies).Count
        InlinePolicyCount = @($inlinePolicyNames).Count
        ReviewedForbiddenActionMatches = @($forbiddenMatches)
        Result = if (@($forbiddenMatches).Count -eq 0) { 'PASS for reviewed actions' } else { 'REVIEW REQUIRED' }
    }
}
