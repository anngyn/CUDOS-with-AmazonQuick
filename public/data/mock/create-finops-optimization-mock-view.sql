-- Prerequisite: create finops_demo.finops_connected_demo_source_mock first.
-- Run this single statement in Athena (Region: ap-southeast-2).
CREATE OR REPLACE VIEW finops_demo.finops_optimization_outcome_mock AS
WITH optimization_rows AS (
    SELECT
        usage_date,
        net_unblended_cost AS daily_cost,
        CASE
            WHEN usage_date BETWEEN DATE '2026-07-01' AND DATE '2026-07-07' THEN 'BASELINE'
            ELSE 'MEASUREMENT'
        END AS period_type
    FROM finops_demo.finops_connected_demo_source_mock
    WHERE service = 'AmazonEC2'
      AND environment = 'staging'
      AND usage_date BETWEEN DATE '2026-07-01' AND DATE '2026-07-14'
),
measured_totals AS (
    SELECT
        optimization_rows.*,
        SUM(CASE WHEN period_type = 'BASELINE' THEN daily_cost ELSE DECIMAL '0.00' END) OVER () AS baseline_cost,
        SUM(CASE WHEN period_type = 'MEASUREMENT' THEN daily_cost ELSE DECIMAL '0.00' END) OVER () AS measurement_cost
    FROM optimization_rows
)
SELECT
    'SYNTHETIC' AS data_classification,
    TRUE AS is_synthetic,
    'MOCK-FIN-001' AS finding_id,
    usage_date,
    period_type,
    'AmazonEC2' AS service,
    'staging' AS environment,
    'Demo Workloads' AS account_name,
    'ap-southeast-2' AS region,
    'Demo Platform Team' AS owner,
    'Staging instances remained active overnight' AS confirmed_cause,
    'Stop staging instances from 20:00 to 07:00' AS approved_action,
    daily_cost,
    CASE WHEN usage_date = DATE '2026-07-01' THEN baseline_cost END AS baseline_total,
    CASE WHEN usage_date = DATE '2026-07-01' THEN measurement_cost END AS measurement_total,
    CASE WHEN usage_date = DATE '2026-07-01' THEN DECIMAL '0.00' END AS demand_adjustment,
    CASE WHEN usage_date = DATE '2026-07-01' THEN baseline_cost - measurement_cost END AS realized_savings,
    CASE WHEN usage_date = DATE '2026-07-01' THEN ROUND(
        DECIMAL '100.00' * (baseline_cost - measurement_cost) / baseline_cost,
        2
    ) END AS savings_percentage,
    CASE WHEN usage_date = DATE '2026-07-01' THEN 'APPROVED' END AS approval_status,
    CASE WHEN usage_date = DATE '2026-07-01' THEN 'VALIDATED' END AS outcome_status,
    CASE WHEN usage_date = DATE '2026-07-01' THEN 'Restore the original instance schedule' END AS rollback_plan,
    CASE WHEN usage_date = DATE '2026-07-01' THEN 'None observed' END AS side_effects
FROM measured_totals;

-- Optional validation query. Run separately after the view has been created.
SELECT
    MAX(baseline_total) AS baseline_total,
    MAX(measurement_total) AS measurement_total,
    MAX(realized_savings) AS realized_savings,
    MAX(savings_percentage) AS savings_percentage
FROM finops_demo.finops_optimization_outcome_mock;
