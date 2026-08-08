---
title: "AWS CLI & Permissions Setup"
weight: 1
chapter: false
pre: "2.1 "
description: "Verify CLI access, identity, Region, and deployment permissions."
duration: "10 mins"
services:
  - AWS CLI
  - AWS STS
  - AWS IAM
---
{{< badge "AWS CLI" >}}
{{< badge "AWS STS" >}}
{{< badge "AWS IAM" >}}
{{< duration "10 mins" >}}

# AWS CLI & Permissions Setup

## Step 1 — Verify AWS CLI

Open PowerShell:

```powershell
aws --version
```

You should receive the installed AWS CLI version.

{{< note >}}
📸 **Screenshot placeholder — `02-01-aws-cli-version.png`**

Capture the PowerShell window showing a successful `aws --version` command.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Verify the workshop identity

Use your configured profile:

```powershell
aws sts get-caller-identity --profile <PROFILE>
```

Record the account ID and ARN locally. Do not paste credentials into the workshop.

{{< note >}}
📸 **Screenshot placeholder — `02-02-caller-identity.png`**

Capture the STS caller identity. Redact account-specific information before publishing if desired.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Set the workshop Region for the current terminal

```powershell
$env:AWS_PROFILE="<PROFILE>"
$env:AWS_REGION="ap-southeast-2"
$env:AWS_DEFAULT_REGION="ap-southeast-2"
```

Check Region availability:

```powershell
aws ec2 describe-regions `
  --region ap-southeast-2 `
  --query "Regions[?RegionName=='ap-southeast-2'].RegionName" `
  --output text
```

Expected:

```text
ap-southeast-2
```

{{< note >}}
📸 **Screenshot placeholder — `02-03-sydney-region.png`**

Capture the AWS Console Region selector or the CLI result confirming Asia Pacific (Sydney).

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Understand required permission areas

The identity used to deploy the workshop needs access to the resources created in later modules, including CloudFormation, Billing/Data Exports, S3, Glue, Athena, IAM resources required by official templates, and Quick Sight.

Do **not** attach `AdministratorAccess` merely because a later step fails. Use the CloudFormation event or AWS error to identify the missing permission.

## Step 5 — Record the Account ID

```powershell
aws sts get-caller-identity `
  --profile <PROFILE> `
  --query Account `
  --output text
```

Store it as `<ACCOUNT_ID>` in your notes. Module 3 uses it for Data Collection parameters.

{{< security >}}
Never publish access keys, session tokens, or credential files. Account IDs and ARNs are not passwords, but public workshop screenshots should still be reviewed before publication.
{{< /security >}}

{{< validation >}}
You are ready when the CLI authenticates successfully and the target Region is `ap-southeast-2`.
{{< /validation >}}
