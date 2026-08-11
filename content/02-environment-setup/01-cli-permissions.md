---
title: "Execution Identity, Region & Permission Boundary"
weight: 1
chapter: false
pre: "2.1 "
description: "Define the identity, Region, and least-privilege boundary used to deploy and validate the FinOps stack."
services:
  - AWS CLI
  - AWS STS
  - AWS IAM
---
{{< badge "AWS CLI" >}}
{{< badge "AWS STS" >}}
{{< badge "AWS IAM" >}}

## Role in the project

The deployment identity is part of the architecture, not a preparatory checkbox. It creates or inspects billing exports, S3, Glue, Athena, IAM resources from AWS-maintained templates, and Quick Sight assets. If that identity is ambiguous, later evidence cannot prove which account or Region owns the data.

The implementation uses a named AWS CLI profile and fixes the analytical Region to `ap-southeast-2`. This produces a repeatable execution context while keeping credentials outside the repository.

## Identity contract

The following probes establish the account and principal used for the project:

```powershell
aws --version

aws sts get-caller-identity `
  --profile <PROFILE>
```

The retained record contains only:

```text
Profile alias:
AWS account ID:
Principal ARN/type:
Validation timestamp:
```

Access keys, session tokens, and credential files are never project artifacts.

## Region decision

The collection and BI components are implemented in Sydney:

```powershell
$env:AWS_PROFILE="<PROFILE>"
$env:AWS_REGION="ap-southeast-2"
$env:AWS_DEFAULT_REGION="ap-southeast-2"

aws ec2 describe-regions `
  --region ap-southeast-2 `
  --query "Regions[?RegionName=='ap-southeast-2'].RegionName" `
  --output text
```

Using one Region reduces ambiguity across CloudFormation, Glue, Athena, Quick Sight, and SPICE. Billing management is global, but the supporting analytical resources are regional.

## Permission boundary

The deployment identity needs enough access to create the official CID data-collection and dashboard resources. The analytical users that consume the finished system need only read/query/dashboard permissions.

```text
Deployment identity
→ create/update collection and BI assets

Analyst identity
→ read S3 through approved query paths
→ query Glue/Athena
→ consume or edit approved Quick Sight assets

AI/Flow identity
→ read approved analytical sources
→ no EC2/RDS/IAM destructive permissions
```

An `AccessDenied` event is investigated at the failed CloudFormation logical resource. Attaching `AdministratorAccess` would hide the missing permission and weaken the project’s security claim.

{{< validation >}}
The execution context is valid when the CLI resolves one known account/principal, the target Region is `ap-southeast-2`, and the deployment and analytical identities have distinct responsibilities.
{{< /validation >}}

{{< security >}}
Account IDs and ARNs are identifiers rather than passwords, but public artifacts are still reviewed to avoid disclosing internal account structure unintentionally.
{{< /security >}}
