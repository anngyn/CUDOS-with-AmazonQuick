---
title: "Prerequisites & AWS Identity Check"
weight: 2
chapter: false
pre: "3.2 "
description: "Verify the account information required by the Data Exports stack."
duration: "5 mins"
services:
  - AWS STS
  - AWS Billing
  - AWS CloudFormation
---
{{< badge "AWS STS" >}}
{{< badge "AWS Billing" >}}
{{< badge "AWS CloudFormation" >}}
{{< duration "5 mins" >}}


## Step 1 — Get the Account ID

```powershell
aws sts get-caller-identity `
  --profile <PROFILE> `
  --query Account `
  --output text
```

Copy the value into your private workshop notes as:

```text
<ACCOUNT_ID>
```

{{< note >}}
📸 **Screenshot placeholder — `03-02-account-id.png`**

Capture the successful account ID lookup. Redact the value before publishing if desired.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Confirm the target Region

Use:

```text
Asia Pacific (Sydney)
ap-southeast-2
```

{{< note >}}
📸 **Screenshot placeholder — `03-03-region-confirmation.png`**

Capture the AWS Console Region selector showing Asia Pacific (Sydney).

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Check Billing and Cost Management access

Open **Billing and Cost Management** and confirm you can access **Data Exports**.

{{< note >}}
📸 **Screenshot placeholder — `03-04-data-exports-home.png`**

Capture the Data Exports console before creating the workshop export.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Check CloudFormation access

Open **AWS CloudFormation → Stacks** in Sydney.

Do not create a stack manually yet. Module 3.3 uses the current official CID Data Exports Launch Stack.

{{< validation >}}
Continue only when you know the current account ID, are in `ap-southeast-2`, and can access both Data Exports and CloudFormation.
{{< /validation >}}
