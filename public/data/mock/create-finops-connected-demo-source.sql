-- Run statement 1 separately only if the database does not already exist.
CREATE DATABASE IF NOT EXISTS finops_demo;

-- Run statement 2 separately in Athena (Region: ap-southeast-2).
-- This is the single synthetic cost source for sections 5.x, 6.1, and 6.2.
CREATE OR REPLACE VIEW finops_demo.finops_connected_demo_source_mock AS
WITH reporting_dates AS (
    SELECT usage_date
    FROM UNNEST(
        SEQUENCE(DATE '2026-07-01', DATE '2026-07-31', INTERVAL '1' DAY)
    ) AS date_rows (usage_date)
),
workload_catalog AS (
    SELECT *
    FROM (
        VALUES
            ('AmazonEC2',       'Compute',    'staging',    'Demo Workloads',    'Demo Platform Team', 'demo-staging',     'i-demo-staging-01',       TRUE,  'Staging compute'),
            ('AmazonEC2',       'Compute',    'production', 'Platform Team',     'Platform Team',      'prod-platform',    'i-demo-platform-01',      FALSE, 'Platform compute'),
            ('AmazonRDS',       'Database',   'production', 'Data Team',         'Data Team',          'prod-data',        'db-demo-rds-01',          FALSE, 'Operational database'),
            ('AWSLambda',       'Serverless', 'production', 'Application Team',  'Application Team',   'prod-application', 'function-demo-inference', FALSE, 'Inference API'),
            ('AmazonS3',        'Storage',    'production', 'Data Team',         'Data Team',          'prod-data',        'bucket-demo-analytics',   FALSE, 'Analytics storage'),
            ('AWSDataTransfer', 'Network',    'shared',     'Unallocated',       'Unallocated',        'shared-services',  'data-transfer-demo',      FALSE, 'Shared network transfer')
    ) AS catalog (
        service,
        service_category,
        environment,
        owner,
        allocation_owner,
        account_name,
        resource_id,
        is_optimization_target,
        workload_name
    )
)
SELECT
    'SYNTHETIC' AS data_classification,
    TRUE AS is_synthetic,
    CAST(usage_date AS DATE) AS usage_date,
    CAST(DATE_TRUNC('month', usage_date) AS DATE) AS billing_period,
    service,
    service_category,
    environment,
    owner,
    allocation_owner,
    account_name,
    'demo-account-001' AS account_id,
    'ap-southeast-2' AS region,
    resource_id,
    workload_name,
    is_optimization_target,
    'Usage' AS charge_type,
    CASE
        WHEN environment = 'staging' AND usage_date BETWEEN DATE '2026-07-01' AND DATE '2026-07-07'
            THEN 'Baseline: instances active overnight'
        WHEN environment = 'staging' AND usage_date BETWEEN DATE '2026-07-08' AND DATE '2026-07-14'
            THEN 'Measurement: scheduled outside business hours'
        ELSE 'Standard workload usage'
    END AS usage_pattern,
    CAST(
        CASE
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-01' THEN DECIMAL '6.10'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-02' THEN DECIMAL '5.90'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-03' THEN DECIMAL '6.00'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-04' THEN DECIMAL '6.20'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-05' THEN DECIMAL '5.80'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-06' THEN DECIMAL '6.10'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-07' THEN DECIMAL '5.90'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-08' THEN DECIMAL '3.80'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-09' THEN DECIMAL '3.90'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-10' THEN DECIMAL '3.70'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-11' THEN DECIMAL '4.00'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-12' THEN DECIMAL '3.80'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-13' THEN DECIMAL '3.90'
            WHEN environment = 'staging' AND usage_date = DATE '2026-07-14' THEN DECIMAL '3.90'
            WHEN environment = 'staging' THEN DECIMAL '3.90'
            WHEN service = 'AmazonEC2' THEN DECIMAL '18.00'
            WHEN service = 'AmazonRDS' THEN DECIMAL '8.60'
            WHEN service = 'AWSLambda' THEN DECIMAL '3.20'
            WHEN service = 'AmazonS3' THEN DECIMAL '2.70'
            WHEN service = 'AWSDataTransfer' THEN DECIMAL '1.20'
        END AS DECIMAL(12, 2)
    ) AS net_unblended_cost
FROM reporting_dates
CROSS JOIN workload_catalog;

-- Optional validation query. Run only after the view has been created.
SELECT
    billing_period,
    ROUND(SUM(net_unblended_cost), 2) AS total_cost,
    COUNT(*) AS cost_rows
FROM finops_demo.finops_connected_demo_source_mock
GROUP BY billing_period
ORDER BY billing_period;
