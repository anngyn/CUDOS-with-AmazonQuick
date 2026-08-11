$ErrorActionPreference = 'Stop'
$env:PYTHONUTF8 = '1'
$env:PYTHONIOENCODING = 'utf-8'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$region = 'ap-southeast-2'
$accountId = aws sts get-caller-identity --region $region --query Account --output text
$analysisId = 'finops-decision-dashboard-analysis'
$dashboardId = 'finops-decision-dashboard'
$dataSetIdentifier = 'CUDOS Dashboard Demo [Synthetic]'
$highSpendVisualId = 'kpi-high-spend-cost'

function Set-Measure {
    param([object]$measure, [string]$fieldId, [string]$columnName)

    $measure.NumericalMeasureField.FieldId = $fieldId
    $measure.NumericalMeasureField.Column.DataSetIdentifier = $dataSetIdentifier
    $measure.NumericalMeasureField.Column.ColumnName = $columnName
    $measure.NumericalMeasureField.AggregationFunction = [pscustomobject]@{
        SimpleNumericalAggregation = 'SUM'
    }
}

function New-GridElement {
    param(
        [string]$elementId,
        [string]$elementType,
        [int]$columnIndex,
        [int]$columnSpan,
        [int]$rowIndex,
        [int]$rowSpan
    )

    [pscustomobject]@{
        ElementId = $elementId
        ElementType = $elementType
        ColumnIndex = $columnIndex
        ColumnSpan = $columnSpan
        RowIndex = $rowIndex
        RowSpan = $rowSpan
    }
}

function Refine-Definition {
    param([object]$definition)

    $definition.CalculatedFields = @(
        [pscustomobject]@{
            Name = 'Spend Band'
            Expression = "ifelse({net_unblended_cost} >= 15, 'High Spend', 'Standard Spend')"
            DataSetIdentifier = $dataSetIdentifier
        },
        [pscustomobject]@{
            Name = 'High Spend Cost'
            Expression = "ifelse({net_unblended_cost} >= 15, {net_unblended_cost}, 0)"
            DataSetIdentifier = $dataSetIdentifier
        }
    )

    $sheet = $definition.Sheets[0]
    $sheet.Name = 'FinOps Decision View'
    $sheet.TextBoxes[0].Content = @'
<text-box>
  <block align="center">
    <inline font-size="24px">
      <b>FinOps Decision View [Synthetic] | Prioritize High Spend Resources | July 2026 | Athena Direct Query | ap-southeast-2 (Sydney)</b>
    </inline>
  </block>
</text-box>
'@

    $totalCostKpi = $sheet.Visuals[0].KPIVisual
    $totalCostKpi.Title.FormatText.RichText = '<visual-title>Selected Period Net Unblended Cost (USD)</visual-title>'

    $highSpendVisual = $sheet.Visuals | Where-Object { $_.KPIVisual -and $_.KPIVisual.VisualId -eq $highSpendVisualId } | Select-Object -First 1
    if ($null -eq $highSpendVisual) {
        $highSpendKpi = (($totalCostKpi | ConvertTo-Json -Depth 100 -Compress) | ConvertFrom-Json)
        $highSpendKpi.VisualId = $highSpendVisualId
        $sheet.Visuals += [pscustomobject]@{ KPIVisual = $highSpendKpi }
    } else {
        $highSpendKpi = $highSpendVisual.KPIVisual
    }
    $highSpendKpi.Title.FormatText.RichText = '<visual-title>High Spend Cost (USD)</visual-title>'
    Set-Measure $highSpendKpi.ChartConfiguration.FieldWells.Values[0] 'source.high_spend_cost' 'High Spend Cost'

    $line = $sheet.Visuals[1].LineChartVisual
    $line.Title.FormatText.RichText = '<visual-title>Daily Net Unblended Cost - July 2026</visual-title>'

    $bar = $sheet.Visuals[2].BarChartVisual
    $bar.Title.FormatText.PlainText = 'Cost Drivers by Service (USD)'

    $pie = $sheet.Visuals[3].PieChartVisual
    $pie.Title.FormatText.PlainText = 'Spend Band Distribution'

    $table = $sheet.Visuals[4].TableVisual
    $table.Title.FormatText.RichText = '<visual-title>Decision Scope and Spend Band Validation</visual-title>'

    $grid = $sheet.Layouts[0].Configuration.GridLayout
    $textBoxId = $sheet.TextBoxes[0].SheetTextBoxId
    $grid.Elements = @(
        (New-GridElement $textBoxId 'TEXT_BOX' 0 36 0 2),
        (New-GridElement $totalCostKpi.VisualId 'VISUAL' 0 9 2 6),
        (New-GridElement $highSpendKpi.VisualId 'VISUAL' 9 9 2 6),
        (New-GridElement $table.VisualId 'VISUAL' 18 18 2 6),
        (New-GridElement $pie.VisualId 'VISUAL' 0 12 8 12),
        (New-GridElement $bar.VisualId 'VISUAL' 12 12 8 12),
        (New-GridElement $line.VisualId 'VISUAL' 24 12 8 12)
    )

    $definition
}

$analysisDefinition = (
    aws quicksight describe-analysis-definition --aws-account-id $accountId --analysis-id $analysisId --region $region --output json |
    ConvertFrom-Json
).Definition
$analysisDefinition = Refine-Definition $analysisDefinition
$analysisJson = $analysisDefinition | ConvertTo-Json -Depth 100 -Compress
aws quicksight update-analysis --aws-account-id $accountId --analysis-id $analysisId --name 'FinOps Decision Dashboard [Synthetic] analysis' --definition $analysisJson --region $region --output text | Out-Null

$dashboardDefinition = (
    aws quicksight describe-dashboard-definition --aws-account-id $accountId --dashboard-id $dashboardId --region $region --output json |
    ConvertFrom-Json
).Definition
$dashboardDefinition = Refine-Definition $dashboardDefinition
$dashboardDefinition.PSObject.Properties.Remove('QueryExecutionOptions')
$dashboardJson = $dashboardDefinition | ConvertTo-Json -Depth 100 -Compress
$response = aws quicksight update-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --name 'FinOps Decision Dashboard [Synthetic]' --definition $dashboardJson --version-description 'Decision-focused layout with High Spend cost and Spend Band validation.' --region $region --output json | ConvertFrom-Json
$version = [int]($response.VersionArn -replace '^.*/version/', '')

do {
    Start-Sleep -Seconds 2
    $dashboard = aws quicksight describe-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --version-number $version --region $region --output json | ConvertFrom-Json
    $status = $dashboard.Dashboard.Version.Status
} while ($status -eq 'UPDATE_IN_PROGRESS')

if ($status -notin @('UPDATE_SUCCESSFUL', 'CREATION_SUCCESSFUL')) {
    throw "Dashboard update failed with status $status."
}

aws quicksight update-dashboard-published-version --aws-account-id $accountId --dashboard-id $dashboardId --version-number $version --region $region --output text | Out-Null
Write-Output "Published decision dashboard version $version."
