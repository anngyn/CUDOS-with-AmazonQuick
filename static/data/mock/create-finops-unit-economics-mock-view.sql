-- Prerequisite: create finops_demo.finops_connected_demo_source_mock first.
-- Run this single statement in Athena (Region: ap-southeast-2).
CREATE OR REPLACE VIEW finops_demo.finops_unit_economics_mock AS
WITH owner_costs AS (
    SELECT
        billing_period,
        allocation_owner AS owner_name,
        service,
        CASE
            WHEN allocation_owner = 'Unallocated' THEN 'UNALLOCATED'
            ELSE 'ALLOCATED'
        END AS allocation_status,
        SUM(net_unblended_cost) AS eligible_cost
    FROM finops_demo.finops_connected_demo_source_mock
    GROUP BY
        billing_period,
        allocation_owner,
        service
),
derived_metrics AS (
    SELECT
        owner_costs.*,
        SUM(eligible_cost) OVER () AS derived_total_eligible_cost,
        SUM(
            CASE WHEN allocation_status = 'ALLOCATED'
                THEN eligible_cost ELSE DECIMAL '0.00' END
        ) OVER () AS derived_allocated_cost,
        SUM(
            CASE WHEN allocation_status = 'UNALLOCATED'
                THEN eligible_cost ELSE DECIMAL '0.00' END
        ) OVER () AS derived_unallocated_cost
    FROM owner_costs
)
SELECT
    'SYNTHETIC' AS data_classification,
    TRUE AS is_synthetic,
    billing_period AS reporting_period,
    'Australia/Sydney' AS reporting_timezone,
    'allocation_owner' AS primary_ownership_dimension,
    ROW_NUMBER() OVER (ORDER BY owner_name, service) AS allocation_line_id,
    owner_name,
    service,
    allocation_status,
    eligible_cost,
    CASE WHEN service = 'AWSLambda'
        THEN derived_total_eligible_cost END AS total_eligible_cost,
    CASE WHEN service = 'AWSLambda'
        THEN derived_allocated_cost END AS allocated_cost,
    CASE WHEN service = 'AWSLambda'
        THEN derived_unallocated_cost END AS unallocated_cost,
    CASE WHEN service = 'AWSLambda' THEN ROUND(
        DECIMAL '100.00' * derived_allocated_cost / derived_total_eligible_cost,
        2
    ) END AS allocation_coverage_percentage,
    CASE WHEN service = 'AWSLambda'
        THEN owner_name END AS unit_economics_owner,
    CASE WHEN service = 'AWSLambda'
        THEN eligible_cost END AS workload_cost,
    CASE WHEN service = 'AWSLambda'
        THEN 'Successful inference requests' END AS business_metric_name,
    CASE WHEN service = 'AWSLambda'
        THEN CAST(49600 AS BIGINT) END AS business_volume,
    CASE WHEN service = 'AWSLambda' THEN CAST(
        ROUND(CAST(eligible_cost AS DOUBLE) / 49600.0 * 1000.0, 2)
        AS DECIMAL(12, 2)
    ) END AS cost_per_1000_requests,
    CASE WHEN service = 'AWSLambda'
        THEN 'VALIDATED' END AS metric_status
FROM derived_metrics;

-- Optional validation query. Run separately after the view has been created.
SELECT
    MAX(total_eligible_cost) AS total_eligible_cost,
    MAX(allocated_cost) AS allocated_cost,
    MAX(unallocated_cost) AS unallocated_cost,
    MAX(allocation_coverage_percentage) AS allocation_coverage_percentage,
    MAX(workload_cost) AS inference_workload_cost,
    MAX(business_volume) AS successful_requests,
    MAX(cost_per_1000_requests) AS cost_per_1000_requests
FROM finops_demo.finops_unit_economics_mock;
