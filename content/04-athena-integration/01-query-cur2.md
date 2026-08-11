---
title: "Athena Validation & CUDOS Reconciliation"
weight: 1
chapter: false
pre: "4.1 "
description: "Use Athena as an independent, reproducible validation layer for CUR 2.0 and CUDOS metrics."
services:
  - Amazon Athena
  - CUR 2.0
---
{{< badge "Amazon Athena" >}}
{{< badge "SQL" >}}
{{< badge "CUR 2.0" >}}

## Validation role

Athena is the project’s independent calculation layer. CUDOS is trusted only after a named metric can be reproduced from the same CUR data, period, account scope, and filters.

This separation catches two common problems:

```text
Correct SQL + stale SPICE
→ Athena and CUDOS differ because refresh times differ.

Fresh data + different cost metrics
→ both numbers are internally correct but answer different questions.
```

## Environment-specific identifiers

The generated database and table names are discovered from the deployed environment and recorded as `<CUR_DATABASE>` and `<CUR2_TABLE>`. They are not hard-coded from an older template version.

```sql
SHOW TABLES IN <CUR_DATABASE>;
```

The current evidence uses database `cid_data_export` and table `cur2`.

## Readability and schema evidence

A bounded sample proves that Glue points Athena to readable objects:

```sql
SELECT *
FROM <CUR_DATABASE>.<CUR2_TABLE>
LIMIT 10;
```

The schema is inspected before analytical SQL is written:

```sql
DESCRIBE <CUR_DATABASE>.<CUR2_TABLE>;
```

Required groups include billing period, usage account, service/product, usage time, Region, line-item type, cost, reservation, Savings Plans, tags, and Cost Categories.

## Baseline service-cost query

The first analytical result groups unblended cost by service:

```sql
SELECT
    line_item_product_code AS service,
    ROUND(SUM(line_item_unblended_cost), 2) AS unblended_cost
FROM <CUR_DATABASE>.<CUR2_TABLE>
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;
```

The cost metric is named explicitly. Replacing `unblended_cost` with amortized or net cost changes the financial meaning and requires a separate metric definition.

## Query-efficiency evidence

Runtime and bytes scanned are retained with the SQL. They show whether a recurring query projects only necessary columns and benefits from Parquet and date filtering.

{{< capture src="images/04-athena/04-01-athena-cur2-validation.svg" alt="Sanitized live Athena validation showing a CUR 2.0 query contract and execution statistics" title="Athena CUR 2.0 validation" capture="Sanitized evidence from a successful live Athena query against cid_data_export.cur2. It shows the August 2026 service-cost contract, primary workgroup, row count, scan size, and SSE-S3 output encryption; financial values are intentionally redacted." caption="One representative Athena execution proves the CUR data is queryable and supplies a named-metric baseline for later CUDOS reconciliation. It does not alone prove the dashboard matches." >}}

[Download the machine-readable Athena validation record](/data/audits/04-01-athena-cur2-validation.json)

{{< cost >}}
Athena charges by data scanned. Reusable queries therefore use Parquet, explicit columns, billing-period filters, and aggregated views rather than recurring `SELECT *` scans.
{{< /cost >}}

## Reconciliation contract with CUDOS

After CUDOS is deployed, the same period total is calculated in Athena:

```sql
SELECT
    DATE_TRUNC('month', line_item_usage_start_date) AS usage_month,
    ROUND(SUM(line_item_unblended_cost), 2) AS unblended_cost
FROM <CUR_DATABASE>.<CUR2_TABLE>
WHERE line_item_usage_start_date >= TIMESTAMP '<START_YYYY-MM-DD 00:00:00>'
  AND line_item_usage_start_date <  TIMESTAMP '<END_EXCLUSIVE_YYYY-MM-DD 00:00:00>'
GROUP BY 1
ORDER BY 1;
```

```text
Period and timezone:
Account/Region filters:
Cost metric:
Athena value:
CUDOS value:
Absolute variance = CUDOS - Athena:
Variance % = absolute variance / Athena × 100:
Last CUR delivery:
Last SPICE refresh:
Status: MATCH / EXPLAINED DIFFERENCE / INVESTIGATE
```

A `1%` tolerance is only an example. It is valid only when scope and metric are identical. Differences are investigated through refresh lag, partial-month data, credits/refunds, account filters, currency, and metric semantics before business conclusions are drawn.

{{< validation >}}
Athena validation is complete when the data is readable, required columns exist, the saved SQL produces a named metric, and the metric has a documented reconciliation contract with CUDOS.
{{< /validation >}}
