---
title: "Querying CUR 2.0 with Amazon Athena"
weight: 1
chapter: false
pre: "<b>4.1 </b>"
description: "Run SQL queries against CUR 2.0 Parquet data using Amazon Athena."
duration: "20 mins"
services:
  - Amazon Athena
  - AWS Glue
---

# Querying CUR 2.0 with Amazon Athena

{{< badge "Amazon Athena" >}} {{< badge orange "AWS Glue" >}}
{{< duration "20 mins" >}}

Once the CUR 2.0 Data Export stack completes, AWS Glue registers the Parquet files into the Glue Data Catalog, enabling direct SQL querying via Amazon Athena.

## Step 1 — Inspect Glue Database

Navigate to **AWS Glue → Data Catalog → Databases** and locate the database created by the CID stack (e.g. `athenacurcfn_cid`).

## Step 2 — Run Sample Athena Query

Open **Amazon Athena** query editor and execute the following query to view top spending services:

```sql
SELECT 
  line_item_product_code,
  ROUND(SUM(line_item_unblended_cost), 2) AS total_cost
FROM 
  "athenacurcfn_cid"."cid_cur2"
WHERE 
  year = '2026' AND month = '8'
GROUP BY 
  line_item_product_code
ORDER BY 
  total_cost DESC
LIMIT 10;
```

{{< finops title="FinOps Insight" >}}
Parquet partitioning by year and month significantly reduces data scanned by Athena, lowering query costs and speeding up execution time.
{{< /finops >}}
