---
title: "Account Topology & Deployment Context"
weight: 2
chapter: false
pre: "3.2 "
description: "Record the single-account topology, Region, and control-plane access assumed by the data foundation."
services:
  - AWS STS
  - AWS Billing
  - AWS CloudFormation
---
{{< badge "AWS STS" >}}
{{< badge "AWS Billing" >}}
{{< badge "AWS CloudFormation" >}}

## Topology decision

The initial implementation uses one AWS account as both the billing-data source and the data-collection destination. This reduces cross-account policies and source-stack coordination while the project proves data delivery, schema, and CUDOS compatibility.

```text
Billing source account
        =
Data collection account
```

The design can later evolve to a management/payer source with a dedicated data account, but that extension should not be mixed into the first validation because it introduces a separate IAM and organizational failure domain.

## Recorded deployment context

The account identifier is obtained from STS rather than copied from an old screenshot or template:

```powershell
aws sts get-caller-identity `
  --profile <PROFILE> `
  --query Account `
  --output text
```

The project context is recorded as:

```text
Source account: <ACCOUNT_ID>
Destination account: <ACCOUNT_ID>
Deployment Region: ap-southeast-2
Billing/Data Exports access: confirmed
CloudFormation access: confirmed
```

{{< evidence src="images/03-cur2/03-01-data-exports-home.png" alt="AWS Billing and Cost Management Data Exports console" caption="Data Exports control plane before the project export was created." >}}

## Architectural implication

Putting the same account first in `SourceAccountIds` selects the official single-account path. As a result, the separate source stack is not required. If source and destination later diverge, this assumption must be revisited rather than copied into the multi-account design.

{{< validation >}}
The deployment context is valid when source account, destination account, Region, and control-plane access are explicit and consistent with the selected single-account architecture.
{{< /validation >}}
