$ErrorActionPreference = 'Stop'

$region = 'ap-southeast-2'
$accountId = aws sts get-caller-identity --region $region --query Account --output text
$sourceAnalysisId = '4fd33a0a-6f21-45b3-be9d-9fdec9a9feb1'
$analysisId = 'finops-decision-dashboard-analysis'
$dashboardId = 'finops-decision-dashboard'
$dataSetIdentifier = 'CUDOS Dashboard Demo [Synthetic]'

function New-CategoricalField {
    param([string]$fieldId, [string]$columnName)

    [pscustomobject]@{
        CategoricalDimensionField = [pscustomobject]@{
            FieldId = $fieldId
            Column = [pscustomobject]@{
                DataSetIdentifier = $dataSetIdentifier
                ColumnName = $columnName
            }
        }
    }
}

function Set-Measure {
    param([object]$measure, [string]$fieldId, [string]$columnName)

    $measure.NumericalMeasureField.FieldId = $fieldId
    $measure.NumericalMeasureField.Column.DataSetIdentifier = $dataSetIdentifier
    $measure.NumericalMeasureField.Column.ColumnName = $columnName
    $measure.NumericalMeasureField.AggregationFunction = [pscustomobject]@{
        SimpleNumericalAggregation = 'SUM'
    }
}

function Add-VisualLabel {
    param([object]$configuration, [string]$propertyName, [string]$label, [string]$fieldId, [string]$columnName)

    $value = [pscustomobject]@{
        AxisLabelOptions = @(
            [pscustomobject]@{
                CustomLabel = $label
                ApplyTo = [pscustomobject]@{
                    FieldId = $fieldId
                    Column = [pscustomobject]@{
                        DataSetIdentifier = $dataSetIdentifier
                        ColumnName = $columnName
                    }
                }
            }
        )
    }
    $configuration | Add-Member -NotePropertyName $propertyName -NotePropertyValue $value -Force
}

if ((aws quicksight list-analyses --aws-account-id $accountId --region $region --query "AnalysisSummaryList[?AnalysisId=='$analysisId'].AnalysisId" --output text) -eq $analysisId) {
    throw "Analysis $analysisId already exists."
}
if ((aws quicksight list-dashboards --aws-account-id $accountId --region $region --query "DashboardSummaryList[?DashboardId=='$dashboardId'].DashboardId" --output text) -eq $dashboardId) {
    throw "Dashboard $dashboardId already exists."
}

$definition = (
    aws quicksight describe-analysis-definition --aws-account-id $accountId --analysis-id $sourceAnalysisId --region $region --output json |
    ConvertFrom-Json
).Definition

# AI-generated filter identifiers are not reusable through the CLI. This demo
# states its July scope in the header and keeps visual scope transparent.
$definition.PSObject.Properties.Remove('FilterGroups')
$definition.CalculatedFields = @(
    [pscustomobject]@{
        Name = 'Spend Band'
        Expression = "ifelse({net_unblended_cost} >= 15, 'High Spend', 'Standard Spend')"
        DataSetIdentifier = $dataSetIdentifier
    }
)

$sheet = $definition.Sheets[0]
$sheet.Name = 'Decision View and Spend Band'
$sheet.TextBoxes[0].Content = @'
<text-box>
  <block align="center">
    <inline font-size="24px">
      <b>FinOps Decision Dashboard [Synthetic] | Net Unblended Cost | July 2026 | Athena Direct Query | ap-southeast-2 (Sydney)</b>
    </inline>
  </block>
</text-box>
'@

$kpi = $sheet.Visuals[0].KPIVisual
$kpi.Title.FormatText.RichText = '<visual-title>Selected Period Net Unblended Cost (USD)</visual-title>'

$line = $sheet.Visuals[1].LineChartVisual
$line.Title.FormatText.RichText = '<visual-title>Daily Net Unblended Cost - July 2026</visual-title>'

$bar = $sheet.Visuals[2].BarChartVisual
$bar.Title.FormatText = [pscustomobject]@{ PlainText = 'Cost by Service (USD)' }
Add-VisualLabel $bar.ChartConfiguration 'CategoryLabelOptions' 'Service' 'source.service' 'service'
Add-VisualLabel $bar.ChartConfiguration 'ValueLabelOptions' 'Net Unblended Cost (USD)' 'source.net_unblended_cost' 'net_unblended_cost'

$pie = $sheet.Visuals[3].PieChartVisual
$pie.Title.FormatText = [pscustomobject]@{ PlainText = 'Spend Band Distribution - $15 Daily Threshold' }
$pie.ChartConfiguration.FieldWells.PieChartAggregatedFieldWells.Category = @(
    (New-CategoricalField 'source.spend_band' 'Spend Band')
)
$pie.ChartConfiguration.SortConfiguration.CategorySort[0].FieldSort.FieldId = 'source.net_unblended_cost'
Add-VisualLabel $pie.ChartConfiguration 'CategoryLabelOptions' 'Spend Band' 'source.spend_band' 'Spend Band'
Add-VisualLabel $pie.ChartConfiguration 'ValueLabelOptions' 'Net Unblended Cost (USD)' 'source.net_unblended_cost' 'net_unblended_cost'

$table = $sheet.Visuals[4].TableVisual
$table.Title.FormatText.RichText = '<visual-title>Scope and Spend Band Validation</visual-title>'
$table.ChartConfiguration.FieldWells.TableAggregatedFieldWells.GroupBy = @(
    (New-CategoricalField 'source.resource_id' 'resource_id'),
    (New-CategoricalField 'source.service' 'service'),
    (New-CategoricalField 'source.account_name' 'account_name'),
    (New-CategoricalField 'source.spend_band' 'Spend Band')
)
$table.ChartConfiguration.FieldWells.TableAggregatedFieldWells.Values = @(
    [pscustomobject]@{
        NumericalMeasureField = [pscustomobject]@{
            FieldId = 'source.net_unblended_cost'
            Column = [pscustomobject]@{
                DataSetIdentifier = $dataSetIdentifier
                ColumnName = 'net_unblended_cost'
            }
            AggregationFunction = [pscustomobject]@{ SimpleNumericalAggregation = 'SUM' }
        }
    }
)
$table.ChartConfiguration.FieldOptions.SelectedFieldOptions = @(
    [pscustomobject]@{ FieldId = 'source.resource_id'; CustomLabel = 'Resource' },
    [pscustomobject]@{ FieldId = 'source.service'; CustomLabel = 'Service' },
    [pscustomobject]@{ FieldId = 'source.account_name'; CustomLabel = 'Account' },
    [pscustomobject]@{ FieldId = 'source.spend_band'; CustomLabel = 'Spend Band' },
    [pscustomobject]@{ FieldId = 'source.net_unblended_cost'; CustomLabel = 'Net Unblended Cost (USD)' }
)
$table.ChartConfiguration.FieldOptions.Order = @(
    'source.resource_id',
    'source.service',
    'source.account_name',
    'source.spend_band',
    'source.net_unblended_cost'
)
$table.ChartConfiguration.SortConfiguration.RowSort = @(
    @{ FieldSort = @{ FieldId = 'source.net_unblended_cost'; Direction = 'DESC' } }
)

$userArn = "arn:aws:quicksight:us-east-1:$accountId`:user/default/DatTran"
$analysisPermissions = @(
    @{
        Principal = $userArn
        Actions = @(
            'quicksight:DescribeAnalysis',
            'quicksight:DescribeAnalysisPermissions',
            'quicksight:QueryAnalysis',
            'quicksight:UpdateAnalysis',
            'quicksight:DeleteAnalysis',
            'quicksight:RestoreAnalysis',
            'quicksight:UpdateAnalysisPermissions'
        )
    }
) | ConvertTo-Json -Depth 5 -Compress

$analysisJson = $definition | ConvertTo-Json -Depth 100 -Compress
aws quicksight create-analysis --aws-account-id $accountId --analysis-id $analysisId --name 'FinOps Decision Dashboard [Synthetic] analysis' --definition $analysisJson --permissions $analysisPermissions --region $region --output text | Out-Null

$dashboardDefinition = ($analysisJson | ConvertFrom-Json)
$dashboardDefinition.PSObject.Properties.Remove('QueryExecutionOptions')
$dashboardPermissions = @(
    @{
        Principal = $userArn
        Actions = @(
            'quicksight:DescribeDashboard',
            'quicksight:ListDashboardVersions',
            'quicksight:UpdateDashboardPermissions',
            'quicksight:QueryDashboard',
            'quicksight:UpdateDashboard',
            'quicksight:DeleteDashboard',
            'quicksight:DescribeDashboardPermissions',
            'quicksight:UpdateDashboardPublishedVersion'
        )
    }
) | ConvertTo-Json -Depth 5 -Compress
$dashboardJson = $dashboardDefinition | ConvertTo-Json -Depth 100 -Compress
aws quicksight create-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --name 'FinOps Decision Dashboard [Synthetic]' --definition $dashboardJson --permissions $dashboardPermissions --version-description 'Synthetic Direct Query decision view with local Spend Band classification.' --region $region --output text | Out-Null

do {
    Start-Sleep -Seconds 2
    $dashboard = aws quicksight describe-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --region $region --output json | ConvertFrom-Json
    $dashboardStatus = $dashboard.Dashboard.Version.Status
} while ($dashboardStatus -eq 'CREATION_IN_PROGRESS')

if ($dashboardStatus -ne 'CREATION_SUCCESSFUL') {
    throw "Dashboard creation failed with status $dashboardStatus."
}

Write-Output "Created dashboard $dashboardId version $($dashboard.Dashboard.Version.VersionNumber)."
