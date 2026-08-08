---
title: "AWS Glue Data Catalog Inspection"
weight: 2
chapter: false
pre: "4.2 "
description: "Inspect the database, table schema, partitions, and S3 location behind Athena."
duration: "10 mins"
services:
  - AWS Glue
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS Glue" >}}
{{< badge "Data Catalog" >}}
{{< badge "Amazon S3" >}}
{{< duration "10 mins" >}}


## Step 1 — Open the database

Go to:

**AWS Glue → Data Catalog → Databases**

Open:

```text
cid_data_exports
```

{{< note >}}
📸 **Screenshot placeholder — `04-07-glue-database.png`**

Capture the Glue database created by the Data Exports foundation.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Open the CUR 2.0 table

Open the table discovered in Athena.

Review:

- Table name
- Database
- S3 location
- Input/output format
- Parameters

{{< note >}}
📸 **Screenshot placeholder — `04-08-glue-cur2-table.png`**

Capture the CUR 2.0 Glue table details.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Inspect the schema

Identify representative groups for:

- bill
- line item
- product
- pricing
- reservation
- Savings Plans
- tags
- Cost Categories

{{< note >}}
📸 **Screenshot placeholder — `04-09-glue-cur2-schema.png`**

Capture a representative section of the CUR 2.0 schema.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Match Glue to S3

Copy the table **Location** and compare it to the real Data Exports S3 prefix from Module 3.

{{< note >}}
📸 **Screenshot placeholder — `04-10-glue-s3-location.png`**

Capture the Glue table location and matching S3 prefix.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< finops title="FinOps Takeaway" >}}
A wrong schema or wrong S3 location can produce misleading financial analysis even when the SQL is syntactically valid.
{{< /finops >}}
