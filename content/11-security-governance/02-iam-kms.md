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

## Deployed audit result

A sanitized live CLI audit rerun in `ap-southeast-2` on 14 August 2026 confirmed that both the Data Exports and Athena-results buckets use `AES256` default encryption and have all four S3 Block Public Access controls enabled. The `primary` Athena workgroup enforces its configuration and encrypts query results with `SSE_S3`.

The `CidCmdQuickSightDataSourceRole` trust policy permits `quicksight.amazonaws.com`. Its two attached policies and one inline policy were checked for `ec2:TerminateInstances`, `rds:DeleteDBInstance`, and `iam:CreateUser`; none matched. This is a targeted review of the listed workload-changing actions, not a blanket certification of every possible IAM permission.

[Download the machine-readable access-governance audit](/data/audits/11-01-access-governance-audit.json)

## KMS decision

A customer-managed KMS key adds policy control and audit ownership, but also introduces key policy, IAM dependency, recurring cost, and failure modes. It is selected only when an organizational requirement justifies that operational responsibility.

More KMS configuration is not automatically more secure if nobody owns the key policy or recovery path.

This workshop uses AWS-managed S3 encryption (`AES256` / `SSE_S3`) rather than a customer-managed KMS key. No requirement has justified the extra key-policy, recovery, and operational ownership burden of a CMK.

## Evidence hygiene

Published images are reviewed for access keys, session tokens, emails, organization IDs, account/catalog IDs, bucket names, ARNs, and financial values. Redaction changes the published artifact, not the underlying validation record.

{{< capture src="images/11-security-governance/11-01-iam-kms-boundary.svg" alt="Sanitized live CLI audit of the IAM and encryption boundary for the FinOps analytical stack" title="IAM and encryption boundary" capture="Sanitized evidence composite generated from the live CLI audit. It shows S3 default encryption and public-access blocks, Athena result encryption, QuickSight-only trust, and no matches for the reviewed workload-changing actions. Bucket names, principals, ARNs, account IDs, and key IDs are omitted." caption="The audit demonstrates the deployed read-oriented boundary. It is a targeted permission review, not a claim that every IAM permission was exhaustively certified." >}}

{{< security >}}
Least privilege means the minimum permission for the correct identity and resource scope, supported by runtime evidence.
{{< /security >}}
