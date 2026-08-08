---
title: "Validate Data Export & S3 Delivery"
weight: 4
chapter: false
pre: "3.4 "
description: "Verify the generated CUR 2.0 export and its first delivery to S3."
duration: "10 mins + delivery wait"
services:
  - AWS Data Exports
  - Amazon S3
  - CUR 2.0
---
{{< badge "AWS Data Exports" >}}
{{< badge "Amazon S3" >}}
{{< badge "CUR 2.0" >}}
{{< duration "10 mins + delivery wait" >}}


## Step 1 — Verify the export exists

Open:

**Billing and Cost Management → Data Exports**

Find the CUR 2.0 export created by the stack.

Check:

- Export type is CUR 2.0.
- Destination is the workshop collection bucket.
- Export configuration looks healthy.

{{< note >}}
📸 **Screenshot placeholder — `03-10-cur2-export.png`**

Capture the CUR 2.0 export entry and destination. Do not fabricate an export name.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Open the destination bucket

Open the S3 bucket created by `CID-DataExports-Destination`.

The official collection pattern uses a structure similar to:

```text
s3://<prefix>-<destination-account-id>-data-exports/
    <export-name>/<source-account-id>/<export-name>/data/<month-partition>/*.parquet
```

{{< note >}}
📸 **Screenshot placeholder — `03-11-data-export-bucket.png`**

Capture the destination S3 bucket and top-level prefix structure.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Wait for first delivery

AWS documents:

- typically about 24 hours
- potentially up to 72 hours

If Parquet objects are not present yet, return later. Do not create synthetic evidence.

## Step 4 — Inspect the Parquet delivery

After data arrives:

1. Open the export prefix.
2. Navigate to the `data` path.
3. Open the current month partition.
4. Confirm one or more `.parquet` objects exist.

{{< note >}}
📸 **Screenshot placeholder — `03-12-cur2-parquet-delivery.png`**

Capture the S3 object list showing real CUR 2.0 Parquet delivery.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Optional — Historical backfill

AWS documentation describes requesting CUR/FOCUS backfill through AWS Support for up to 36 months. This is optional and support-plan/account dependent.

{{< finops title="FinOps Takeaway" >}}
A successful CloudFormation stack is not the same thing as fresh financial data. Validate delivery separately.
{{< /finops >}}
