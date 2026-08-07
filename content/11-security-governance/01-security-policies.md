---
title: "Security & Governance Policies"
weight: 1
chapter: false
pre: "<b>11.1 </b>"
description: "Secure S3 billing buckets, IAM roles, and Athena query permissions."
duration: "15 mins"
services:
  - AWS IAM
  - AWS KMS
  - Amazon S3
---

# Security & Governance Policies

{{< badge "AWS IAM" >}} {{< badge "AWS KMS" >}}
{{< duration "15 mins" >}}

Protect sensitive financial and usage data by applying strict access control policies.

## Best Practices

- **S3 Bucket Encryption**: Enable SSE-KMS encryption on CUR 2.0 S3 destination buckets.
- **Least Privilege IAM**: Restrict Athena and S3 read permissions to authorized FinOps personnel.
- **Redaction**: Ensure account IDs and IAM ARNs are sanitized in external reports.

{{< security >}}
Ensure public access to S3 destination buckets is explicitly blocked.
{{< /security >}}
