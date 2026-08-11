-- Prerequisite: create finops_demo.finops_connected_demo_source_mock first.
-- Run this single statement in Athena (Region: ap-southeast-2).
CREATE OR REPLACE VIEW finops_demo.cudos_dashboard_demo_mock AS
SELECT
    data_classification,
    is_synthetic,
    usage_date,
    billing_period,
    service,
    service_category,
    environment,
    owner,
    account_name,
    account_id,
    region,
    resource_id,
    workload_name,
    charge_type,
    usage_pattern,
    net_unblended_cost
FROM finops_demo.finops_connected_demo_source_mock;

-- Optional validation query. Run separately after the view has been created.
SELECT
    service,
    ROUND(SUM(net_unblended_cost), 2) AS total_cost
FROM finops_demo.cudos_dashboard_demo_mock
GROUP BY service
ORDER BY total_cost DESC;
