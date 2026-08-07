---
title: "Validate Data Export & S3 Delivery"
weight: 4
chapter: false
pre: "<b>3.4 </b>"
description: "Verify CUR 2.0 Data Export configuration and inspect destination S3 Parquet bucket."
duration: "15 mins"
---

{{< badge "Amazon S3" >}} {{< badge orange "Data Exports" >}}
{{< duration "15 mins" >}}

After the `CID-DataExports-Destination` CloudFormation stack reaches `CREATE_COMPLETE`, verify the created Data Export definition and inspect the destination S3 storage.

## Step 1 — Verify Export in Billing Console

Navigate to **AWS Billing & Cost Management → Data Exports**.

Confirm that the export definition (e.g. `cid-cur2`) exists and displays a **Healthy** status.

<!-- TODO: Replace with screenshot captured during real execution. -->
![CUR 2.0 export created](/images/03-cur2/03-11-cur2-export-created.png)

## Step 2 — Inspect S3 Bucket

Navigate to **Amazon S3** and locate the newly created destination bucket (e.g., `cid-data-exports-<ACCOUNT_ID>`).

{{< note >}}
Initial CUR 2.0 Parquet delivery to S3 typically occurs within 6 to 24 hours. The absence of Parquet files immediately after stack deployment is expected behavior.
{{< /note >}}

<!-- TODO: Replace with screenshot captured during real execution. -->
![CUR destination bucket](/images/03-cur2/03-12-cur2-s3-bucket.png)

{{< finops title="FinOps Takeaway" >}}
Automated data exports ensure your FinOps pipeline has continuous access to raw cost metrics without requiring manual report downloads.
{{< /finops >}}
