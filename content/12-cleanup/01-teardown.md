---
title: "Teardown & Resource Cleanup"
weight: 1
chapter: false
pre: "12.1 "
description: "Delete workshop assets in a dependency-aware order."
duration: "15 mins"
services:
  - Amazon Quick
  - CUDOS v5
  - AWS Data Exports
  - AWS CloudFormation
  - Amazon S3
---
{{< badge "Cleanup" >}}
{{< badge "AWS CloudFormation" >}}
{{< badge "Amazon Quick" >}}
{{< duration "15 mins" >}}


## Step 1 — Create a resource inventory

Record:

- Quick Space
- chat agent
- Quick Flow
- custom Quick Sight analysis/dashboard
- CUDOS assets
- Cost Anomaly Detection monitor/subscription
- SNS topic
- Slack/chat configuration
- Data Export
- CloudFormation stack
- S3 bucket/prefix
- Glue/Athena resources

{{< note >}}
📸 **Screenshot placeholder — `12-01-resource-inventory.png`**

Capture a compact inventory of major workshop resources before deletion.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Remove Amazon Quick advanced assets

Delete only workshop-created:

1. Quick Flow
2. custom chat agent
3. FinOps Space

{{< note >}}
📸 **Screenshot placeholder — `12-02-quick-cleanup.png`**

Capture the Quick asset list after workshop-specific advanced assets are removed.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Remove custom Quick Sight assets

Delete `FinOps Workshop Dashboard` and the workshop analysis if no longer needed.

## Step 4 — Remove CUDOS

Use the supported teardown path for the actual deployment method.

Because this is destructive, verify current syntax with:

```bash
cid-cmd --help
```

Do not guess a delete command.

{{< note >}}
📸 **Screenshot placeholder — `12-03-cudos-cleanup.png`**

Capture the verified CUDOS teardown result.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Remove anomaly-alert resources

If created only for this workshop:

- remove anomaly subscription
- remove custom monitor
- remove SNS topic
- remove Slack/chat mapping

{{< note >}}
📸 **Screenshot placeholder — `12-04-alert-cleanup.png`**

Capture the anomaly/SNS cleanup state.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Remove Data Export / collection stack

AWS guidance notes that the Destination S3 bucket may need to be emptied before deleting the stack.

1. Confirm no shared export depends on it.
2. Remove the workshop Data Export if no longer needed.
3. Empty only workshop-owned S3 data if required.
4. Delete `CID-DataExports-Destination`.
5. Monitor deletion.

{{< note >}}
📸 **Screenshot placeholder — `12-05-data-export-cleanup.png`**

Capture Data Exports after removing the workshop export.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< note >}}
📸 **Screenshot placeholder — `12-06-stack-delete.png`**

Capture CloudFormation after deleting the Data Exports Destination stack.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< cost >}}
Delete only what the workshop created. Leaving resources behind can cost money; deleting shared resources can cause a much larger incident.
{{< /cost >}}
