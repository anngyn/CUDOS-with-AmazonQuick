---
title: "IAM Least Privilege & KMS Encryption"
weight: 2
chapter: false
pre: "11.2 "
description: "Inspect analytical permissions and encryption choices."
duration: "15 mins"
services:
  - AWS IAM
  - AWS KMS
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS IAM" >}}
{{< badge "AWS KMS" >}}
{{< badge "Least Privilege" >}}
{{< duration "15 mins" >}}


## Step 1 — Inspect CID roles/policies

Identify roles/policies created by the official stacks.

Record what they allow across:

- S3
- Glue
- Athena
- Quick Sight
- supporting custom resources

{{< note >}}
📸 **Screenshot placeholder — `11-04-cid-iam-role.png`**

Capture one relevant CID/Quick Sight IAM role and its attached policies.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Verify the analytics boundary

The BI/query path should not require unrelated permissions such as:

```text
ec2:TerminateInstances
rds:DeleteDBInstance
iam:CreateUser
```

## Step 3 — Inspect S3 encryption

Open:

**Data Exports bucket → Properties → Default encryption**

{{< note >}}
📸 **Screenshot placeholder — `11-05-s3-encryption.png`**

Capture the S3 default-encryption configuration.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Inspect Athena results encryption

Open Athena settings/workgroup and inspect query-result configuration.

{{< note >}}
📸 **Screenshot placeholder — `11-06-athena-encryption.png`**

Capture the Athena query-results encryption settings.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Understand KMS trade-offs

A customer-managed KMS key can add control, but also adds:

- key policies
- IAM/KMS dependencies
- operational ownership
- cost

Do not create a CMK only to make the architecture diagram look more secure.

## Step 6 — Review screenshot hygiene

Check public images for credentials, email addresses, organization IDs, access keys, session tokens, and sensitive resource names.

{{< security >}}
Least privilege means the minimum required permission for the correct identity, not simply more IAM and KMS configuration.
{{< /security >}}
