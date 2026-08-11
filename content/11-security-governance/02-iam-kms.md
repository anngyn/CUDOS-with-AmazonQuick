---
title: "IAM, Encryption & Analytical Security Boundary"
weight: 2
chapter: false
pre: "11.2 "
description: "Define least privilege and encryption controls across the CUR, Athena, CUDOS, and AI path."
services:
  - AWS IAM
  - AWS KMS
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS IAM" >}}
{{< badge "AWS KMS" >}}
{{< badge "Least Privilege" >}}

## Security boundary

The analytical stack is read-oriented:

```text
Data delivery roles
→ write approved CUR objects and metadata

Query/BI roles
→ read approved S3 prefixes and Glue metadata
→ execute Athena queries
→ refresh and consume Quick Sight assets

AI/Flow roles
→ read approved analytical sources
→ produce explanation/recommendation
```

Permissions such as `ec2:TerminateInstances`, `rds:DeleteDBInstance`, and `iam:CreateUser` are outside this boundary.

## IAM review record

Roles and policies created by the official CID templates are mapped to S3, Glue, Athena, Quick Sight, and supporting custom resources. Each permission is associated with a runtime responsibility rather than accepted because the template is AWS-maintained.

```text
Role/policy:
Principal/service:
Required actions/resources:
Reason:
Unexpected permission:
Review result:
```

## Encryption model

The review covers:

- default encryption on the Data Exports S3 bucket;
- Athena workgroup/query-result encryption;
- KMS permissions required by delivery and query identities;
- key ownership and rotation when a customer-managed key is used.

## KMS decision

A customer-managed KMS key adds policy control and audit ownership, but also introduces key policy, IAM dependency, recurring cost, and failure modes. It is selected only when an organizational requirement justifies that operational responsibility.

More KMS configuration is not automatically more secure if nobody owns the key policy or recovery path.

## Evidence hygiene

Published images are reviewed for access keys, session tokens, emails, organization IDs, account/catalog IDs, bucket names, ARNs, and financial values. Redaction changes the published artifact, not the underlying validation record.

{{< capture src="images/11-security-governance/11-01-iam-kms-boundary.png" alt="Sanitized evidence of the IAM and encryption boundary for the FinOps analytical stack" title="IAM and encryption boundary" capture="Create one sanitized evidence composite showing the analytical role scoped to required S3/Glue/Athena/QuickSight access, S3 default encryption, and Athena query-result encryption. Confirm that workload-changing permissions are absent; redact principals, ARNs, bucket names, account IDs, and key IDs." caption="Security evidence demonstrates the read-oriented boundary without publishing sensitive identifiers." >}}

{{< security >}}
Least privilege means the minimum permission for the correct identity and resource scope, supported by runtime evidence.
{{< /security >}}
