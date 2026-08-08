---
title: "Querying CUR 2.0 with Amazon Athena"
weight: 1
chapter: false
pre: "4.1 "
description: "Run real validation and cost-analysis SQL over CUR 2.0."
duration: "15 mins"
services:
  - Amazon Athena
  - CUR 2.0
---
{{< badge "Amazon Athena" >}}
{{< badge "SQL" >}}
{{< badge "CUR 2.0" >}}
{{< duration "15 mins" >}}


## Step 1 — Open Athena

1. Open **Amazon Athena** in `ap-southeast-2`.
2. Open **Query editor**.
3. Select the Glue Data Catalog.
4. Select database:

```text
cid_data_exports
```

{{< note >}}
📸 **Screenshot placeholder — `04-01-athena-database.png`**

Capture Athena with `cid_data_exports` selected.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Discover the actual CUR table name

Run:

```sql
SHOW TABLES IN cid_data_exports;
```

Identify the CUR 2.0 table and record it as:

```text
<CUR2_TABLE>
```

{{< note >}}
📸 **Screenshot placeholder — `04-02-athena-show-tables.png`**

Capture the `SHOW TABLES` result and highlight the CUR 2.0 table.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Inspect a small sample

```sql
SELECT *
FROM cid_data_exports.<CUR2_TABLE>
LIMIT 10;
```

This is a one-time sanity check, not a recurring analytics pattern.

{{< note >}}
📸 **Screenshot placeholder — `04-03-athena-first-rows.png`**

Capture the successful query and a few returned CUR rows.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Inspect column names

```sql
DESCRIBE cid_data_exports.<CUR2_TABLE>;
```

Look for billing period, usage account, product code, usage start time, Region, line item type, usage type, cost, reservation, Savings Plans, and tag fields.

{{< note >}}
📸 **Screenshot placeholder — `04-04-athena-describe-cur2.png`**

Capture the schema returned by `DESCRIBE`.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Query cost by service

After confirming the actual field names, run:

```sql
SELECT
    line_item_product_code AS service,
    ROUND(SUM(line_item_unblended_cost), 2) AS unblended_cost
FROM cid_data_exports.<CUR2_TABLE>
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;
```

If your table differs, adapt the query to the real schema.

{{< note >}}
📸 **Screenshot placeholder — `04-05-athena-cost-by-service.png`**

Capture the real service-cost result.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Review query statistics

Record:

- run time
- data scanned

{{< note >}}
📸 **Screenshot placeholder — `04-06-athena-query-statistics.png`**

Capture the Athena query statistics.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< cost >}}
Athena cost is driven by scanned data. Date filters, column projection, Parquet, and aggregated views reduce recurring scan cost.
{{< /cost >}}
