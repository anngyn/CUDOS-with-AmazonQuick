# Mock FinOps optimization dashboard

Dataset source:

```text
static/data/mock/finops-optimization-outcome-mock.csv
```

Create a separate Amazon Quick SPICE dataset named:

```text
finops_optimization_outcome_mock
```

## Expected field types

| Field | Type |
|---|---|
| `usage_date` | Date (`yyyy-MM-dd`) |
| `daily_cost` | Decimal |
| `baseline_total` | Decimal |
| `measurement_total` | Decimal |
| `demand_adjustment` | Decimal |
| `realized_savings` | Decimal |
| `savings_percentage` | Decimal |
| `is_synthetic` | Boolean |
| Remaining fields | String |

## Recommended visuals

Use `Max` aggregation for the summary fields because their values are stored only on the first row:

| Visual | Field | Aggregation |
|---|---|---|
| KPI — Baseline cost | `baseline_total` | Max |
| KPI — Measured cost | `measurement_total` | Max |
| KPI — Realized savings | `realized_savings` | Max |
| KPI — Savings rate | `savings_percentage` | Max |
| Line chart | X: `usage_date`; Value: `daily_cost`; Color: `period_type` | Sum |
| Decision table | `finding_id`, `service`, `environment`, `owner`, `approved_action`, `outcome_status` | No aggregation for dimensions |

If the table visual does not expose an aggregation menu, use the corrected Athena view and add a visual filter:

```text
realized_savings is not null
```

The corrected view stores summary values only on the first date row. Therefore `Sum`, `Max`, and an unaggregated table filtered to the non-null summary row all produce one outcome rather than multiplying `$15` by 14 daily rows.

Expected reconciliation of the mock record:

```text
Baseline total:     42.00
Measurement total:  27.00
Demand adjustment:   0.00
Realized savings:    15.00
Savings percentage: 35.71
```

Publish the analysis as a separate dashboard, for example:

```text
FinOps Optimization Demo [SYNTHETIC]
```

Do not join this dataset to `summary_view`, `resource_view`, `hourly_view`, or the authoritative CUR table.

## When no SPICE capacity is available

File upload always requires SPICE. If Amazon Quick reports `You have no SPICE capacity available`, create an isolated Athena view instead:

```text
static/data/mock/create-finops-optimization-mock-view.sql
```

Run the `CREATE DATABASE` statement first, then run the `CREATE OR REPLACE VIEW` statement separately. The validation query should return:

| period_type | days | period_cost |
|---|---:|---:|
| BASELINE | 7 | 42.00 |
| MEASUREMENT | 7 | 27.00 |

In Amazon Quick:

1. Create a dataset from the existing `CID-CMD-Athena` data source.
2. Select database `finops_demo`.
3. Select view `finops_optimization_outcome_mock`.
4. Choose **Direct query**, not **Import to SPICE**.
5. Create the visuals listed above.

Direct query avoids SPICE capacity but incurs Athena query scans. This mock view reads only inline values, so its scan footprint is negligible. CUDOS datasets configured for SPICE still require available SPICE capacity before their ingestion can complete.
