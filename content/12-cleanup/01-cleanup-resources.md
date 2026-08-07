---
title: "Teardown & Resource Cleanup"
weight: 1
chapter: false
pre: "<b>12.1 </b>"
description: "Clean up CloudFormation stacks, S3 buckets, and Glue databases."
duration: "10 mins"
services:
  - AWS CloudFormation
  - Amazon S3
---

{{< badge orange "Cleanup" >}}
{{< duration "10 mins" >}}

To avoid ongoing AWS charges after completing the workshop, follow these cleanup steps.

## Step 1 — Delete CloudFormation Stack

Navigate to **AWS CloudFormation** and delete the `CID-DataExports-Destination` stack.

## Step 2 — Empty & Delete S3 Bucket

Empty and delete the destination S3 bucket created for Data Exports (`cid-data-exports-...`).

## Step 3 — Clean Up Glue Database & QuickSight Assets

Remove any custom QuickSight datasets, analyses, and Glue databases created during the labs.

{{< validation >}}
Verify in CloudFormation console that all workshop stacks have reached `DELETE_COMPLETE`.
{{< /validation >}}
