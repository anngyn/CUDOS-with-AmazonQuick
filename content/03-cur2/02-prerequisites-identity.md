---
title: "Prerequisites & AWS Identity Check"
weight: 2
chapter: false
pre: "<b>3.2 </b>"
description: "Verify AWS CLI credentials, Account ID, and required permissions before stack deployment."
duration: "10 mins"
---

{{< badge "AWS CLI" >}} {{< badge "AWS IAM" >}}
{{< duration "10 mins" >}}

Before deploying the CUR 2.0 destination stack, verify your active IAM session and retrieve your Account ID.

## Step 1 — Confirm Session Identity

Execute the PowerShell command to verify identity:

```powershell
aws sts get-caller-identity --profile DatTran
```

Retrieve your 12-digit Account ID:

```powershell
aws sts get-caller-identity --profile DatTran --query Account --output text
```

This Account ID will be passed into the CloudFormation template for both **Destination Account ID** and **Source Account IDs**.

{{< security >}}
Never publish unredacted account IDs, IAM ARNs, or secret keys in public workshop screenshots or documentation.
{{< /security >}}

<!-- TODO: Replace with screenshot captured during real execution. -->
![Verify AWS Identity](/images/03-cur2/03-01-caller-identity.png)
