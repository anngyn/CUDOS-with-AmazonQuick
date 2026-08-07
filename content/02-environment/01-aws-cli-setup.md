---
title: "AWS CLI & Permissions Setup"
weight: 1
chapter: false
pre: "<b>2.1 </b>"
description: "Prepare AWS CLI credentials, region selection, and IAM permissions for the workshop."
duration: "15 mins"
services:
  - AWS CLI
  - AWS IAM
---

{{< badge "AWS CLI" >}} {{< badge "AWS IAM" >}}
{{< duration "15 mins" >}}

Before building the FinOps pipeline, verify your AWS CLI profile and target Region.

## Step 1 — Verify AWS CLI Identity

Run the following command in PowerShell:

```powershell
aws sts get-caller-identity --profile DatTran
```

Confirm that your Account ID and IAM role/user identity are active.

## Step 2 — Verify Target Region

This workshop uses **Asia Pacific (Sydney) — `ap-southeast-2`**.

{{< note >}}
Ensure your AWS Management Console and CLI defaults are set to `ap-southeast-2` before provisioning CloudFormation stacks.
{{< /note >}}

{{< security >}}
Never hardcode or share AWS secret keys or unredacted account details in public repositories.
{{< /security >}}
