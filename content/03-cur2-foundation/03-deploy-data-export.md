---
title: "Deploy the CUR 2.0 Data Export Foundation"
weight: 3
chapter: false
pre: "3.3 "
description: "Deploy the official CID Data Exports destination stack for a single-account workshop."
duration: "15–20 mins"
services:
  - AWS CloudFormation
  - AWS Data Exports
  - Amazon S3
  - AWS Glue
  - Amazon Athena
---
{{< badge "AWS CloudFormation" >}}
{{< badge "AWS Data Exports" >}}
{{< badge "CUR 2.0" >}}
{{< duration "15–20 mins" >}}


Official guide:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/data-exports.html`

## Step 1 — Launch the Destination stack

1. Open the official guide above.
2. Go to **Deployment → Step 1 of 3 — Create Destination for Data Exports**.
3. Choose **Launch Stack**.
4. When CloudFormation opens, confirm the Region is **Asia Pacific (Sydney)**.

{{< note >}}
📸 **Screenshot placeholder — `03-05-launch-destination-stack.png`**

Capture the official Launch Stack link or the pre-populated CloudFormation create-stack page.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Set the stack name

Use:

```text
CID-DataExports-Destination
```

## Step 3 — Configure account parameters

Use your current account for both roles:

```text
Destination Account ID = <ACCOUNT_ID>
Source Account IDs      = <ACCOUNT_ID>
```

Because this is the single-account test path, place the current account first in `SourceAccountIds`. AWS documents that this lets you **skip Step 2 of 3 (the separate Source stack)**.

## Step 4 — Enable CUR 2.0

Set:

- **Manage CUR 2.0**: `yes`
- FOCUS: disabled for this workshop
- Cost Optimization Hub export: disabled for the core workshop
- Carbon export: disabled

Review any additional parameters exposed by the current template and record their actual values rather than relying on an old screenshot.

{{< note >}}
📸 **Screenshot placeholder — `03-06-destination-parameters.png`**

Capture the parameter screen showing the stack name, destination account, source account IDs, and CUR 2.0 enabled.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Review IAM capability

Continue through **Configure stack options**.

Optional workshop tags:

| Key | Value |
|---|---|
| Project | FinOpsWorkshop |
| Environment | Workshop |

At the Review page:

1. Confirm the Region.
2. Confirm CUR 2.0 is enabled.
3. Confirm Source and Destination are the same account.
4. Acknowledge that CloudFormation might create IAM resources.
5. Create the stack.

{{< note >}}
📸 **Screenshot placeholder — `03-07-review-destination-stack.png`**

Capture the final review screen before creating the stack. Hide account IDs before publication.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Wait for CloudFormation

Open the stack **Events** tab.

You will first see:

```text
CREATE_IN_PROGRESS
```

Wait until:

```text
CREATE_COMPLETE
```

AWS documents roughly 5–15 minutes for this destination step.

{{< note >}}
📸 **Screenshot placeholder — `03-08-destination-stack-complete.png`**

Capture the CloudFormation stack showing `CREATE_COMPLETE`.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

If the stack fails, record the first failed logical resource and **Status reason** from Events.

## Step 7 — Inspect resources

Open the stack **Resources** tab.

Expect collection-side resources such as:

- S3 destination bucket
- Glue database
- Athena tables
- Glue crawlers/supporting resources
- policies required for Data Exports delivery

{{< note >}}
📸 **Screenshot placeholder — `03-09-destination-stack-resources.png`**

Capture the Resources tab so the workshop shows what CloudFormation actually created.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 8 — Skip the separate Source stack

For this single-account workshop, the current account ID was placed first in `SourceAccountIds`, so follow the official single-account path and **skip the separate Source stack**.

{{< validation >}}
The destination stack must be `CREATE_COMPLETE`, CUR 2.0 must be enabled, and the stack resources must be visible before moving to delivery validation.
{{< /validation >}}
