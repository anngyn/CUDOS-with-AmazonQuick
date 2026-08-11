$ErrorActionPreference = 'Stop'
$env:PYTHONUTF8 = '1'
$env:PYTHONIOENCODING = 'utf-8'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$region = 'ap-southeast-2'
$accountId = aws sts get-caller-identity --region $region --query Account --output text
$analysisId = 'finops-unit-economics-analysis'
$dashboardId = 'finops-unit-economics-dashboard'
$dataSetIdentifier = 'FinOps Allocation and Unit Economics [Synthetic]'

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

function Refine-Definition {
    param([object]$definition)

    $sheet = $definition.Sheets[0]
    $bar = $sheet.Visuals[2].BarChartVisual
    $bar.ChartConfiguration | Add-Member -NotePropertyName CategoryLabelOptions -NotePropertyValue ([pscustomobject]@{
        AxisLabelOptions = @(
            [pscustomobject]@{
                CustomLabel = 'Owner'
                ApplyTo = [pscustomobject]@{
                    FieldId = 'source.owner_name'
                    Column = [pscustomobject]@{ DataSetIdentifier = $dataSetIdentifier; ColumnName = 'owner_name' }
                }
            }
        )
    }) -Force
    $bar.ChartConfiguration.ValueLabelOptions = [pscustomobject]@{
        AxisLabelOptions = @(
            [pscustomobject]@{
                CustomLabel = 'Eligible Cost (USD)'
                ApplyTo = [pscustomobject]@{
                    FieldId = 'source.eligible_cost'
                    Column = [pscustomobject]@{ DataSetIdentifier = $dataSetIdentifier; ColumnName = 'eligible_cost' }
                }
            }
        )
    }

    $pie = $sheet.Visuals[3].PieChartVisual
    $pie.Title.FormatText = [pscustomobject]@{ PlainText = 'Allocation Status - 96.85% Allocated' }
    $pie.ChartConfiguration | Add-Member -NotePropertyName CategoryLabelOptions -NotePropertyValue ([pscustomobject]@{
        AxisLabelOptions = @(
            [pscustomobject]@{
                CustomLabel = 'Allocation Status'
                ApplyTo = [pscustomobject]@{
                    FieldId = 'source.allocation_status'
                    Column = [pscustomobject]@{ DataSetIdentifier = $dataSetIdentifier; ColumnName = 'allocation_status' }
                }
            }
        )
    }) -Force
    $pie.ChartConfiguration.ValueLabelOptions = [pscustomobject]@{
        AxisLabelOptions = @(
            [pscustomobject]@{
                CustomLabel = 'Eligible Cost (USD)'
                ApplyTo = [pscustomobject]@{
                    FieldId = 'source.eligible_cost'
                    Column = [pscustomobject]@{ DataSetIdentifier = $dataSetIdentifier; ColumnName = 'eligible_cost' }
                }
            }
        )
    }

    $table = $sheet.Visuals[4].TableVisual
    $table.Title.FormatText.RichText = '<visual-title>Allocation Driver Detail</visual-title>'
    $table.ChartConfiguration.FieldWells.TableAggregatedFieldWells.GroupBy = @(
        (New-CategoricalField 'source.owner_name' 'owner_name'),
        (New-CategoricalField 'source.service' 'service'),
        (New-CategoricalField 'source.allocation_status' 'allocation_status')
    )
    $table.ChartConfiguration.FieldWells.TableAggregatedFieldWells.Values = @(
        [pscustomobject]@{ NumericalMeasureField = [pscustomobject]@{ FieldId = 'source.eligible_cost'; Column = [pscustomobject]@{ DataSetIdentifier = $dataSetIdentifier; ColumnName = 'eligible_cost' }; AggregationFunction = [pscustomobject]@{ SimpleNumericalAggregation = 'SUM' } } }
    )
    $table.ChartConfiguration.FieldOptions.SelectedFieldOptions = @(
        [pscustomobject]@{ FieldId = 'source.owner_name'; CustomLabel = 'Owner' },
        [pscustomobject]@{ FieldId = 'source.service'; CustomLabel = 'Service' },
        [pscustomobject]@{ FieldId = 'source.allocation_status'; CustomLabel = 'Allocation Status' },
        [pscustomobject]@{ FieldId = 'source.eligible_cost'; CustomLabel = 'Eligible Cost (USD)' }
    )
    $table.ChartConfiguration.FieldOptions.Order = @(
        'source.owner_name',
        'source.service',
        'source.allocation_status',
        'source.eligible_cost'
    )
    $table.ChartConfiguration.SortConfiguration.RowSort = @(
        @{ FieldSort = @{ FieldId = 'source.eligible_cost'; Direction = 'DESC' } }
    )

    $definition
}

$analysisDefinition = (
    aws quicksight describe-analysis-definition --aws-account-id $accountId --analysis-id $analysisId --region $region --output json |
    ConvertFrom-Json
).Definition
$analysisDefinition = Refine-Definition $analysisDefinition
$analysisJson = $analysisDefinition | ConvertTo-Json -Depth 100 -Compress
aws quicksight update-analysis --aws-account-id $accountId --analysis-id $analysisId --name 'FinOps Allocation and Unit Economics [Synthetic] analysis' --definition $analysisJson --region $region --output text | Out-Null

$dashboardDefinition = (
    aws quicksight describe-dashboard-definition --aws-account-id $accountId --dashboard-id $dashboardId --region $region --output json |
    ConvertFrom-Json
).Definition
$dashboardDefinition = Refine-Definition $dashboardDefinition
$dashboardDefinition.PSObject.Properties.Remove('QueryExecutionOptions')
$dashboardJson = $dashboardDefinition | ConvertTo-Json -Depth 100 -Compress
$updateResponse = aws quicksight update-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --name 'FinOps Allocation and Unit Economics [Synthetic]' --definition $dashboardJson --version-description 'Refined allocation detail labels and table.' --region $region --output json | ConvertFrom-Json
$version = [int]($updateResponse.VersionArn -replace '^.*/version/', '')

do {
    Start-Sleep -Seconds 2
    $dashboard = aws quicksight describe-dashboard --aws-account-id $accountId --dashboard-id $dashboardId --version-number $version --region $region --output json | ConvertFrom-Json
    $status = $dashboard.Dashboard.Version.Status
} while ($status -eq 'UPDATE_IN_PROGRESS')

if ($status -notin @('UPDATE_SUCCESSFUL', 'CREATION_SUCCESSFUL')) {
    throw "Dashboard update failed with status $status."
}

aws quicksight update-dashboard-published-version --aws-account-id $accountId --dashboard-id $dashboardId --version-number $version --region $region --output text | Out-Null
Write-Output "Published dashboard version $version with refined allocation detail."
