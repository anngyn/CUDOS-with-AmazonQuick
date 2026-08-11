---
title: "Resource Lifecycle & Retention Runbook"
weight: 1
chapter: false
pre: "12.1 "
description: "Make explicit retain-or-delete decisions and remove temporary assets in dependency-aware order."
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


This chapter is intentionally a runbook. Teardown is the one part of the project where operation order matters more than narrative: deleting a source before its consumers are inventoried can destroy evidence, while leaving temporary capacity behind creates ongoing cost.

```text
Inventory and ownership decision
→ advanced AI assets
→ custom BI assets
→ CUDOS assets
→ anomaly routing
→ Data Export and collection stack
→ delayed billing verification
```


## Create a resource inventory

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

Each item receives `RETAIN` or `DELETE`, an owner, and the reason. No delete command is run from an inferred resource name.


## Remove Amazon Quick advanced assets

Delete only project-created:

1. Quick Flow
2. custom chat agent
3. FinOps Space


## Remove custom Quick Sight assets

Delete `FinOps Project Dashboard` and the project analysis if no longer needed.

## Remove CUDOS

Use the supported teardown path for the actual deployment method.

Because this is destructive, verify current syntax with:

```bash
cid-cmd --help
```

Do not guess a delete command.


## Remove anomaly-alert resources

If created only for this project:

- remove anomaly subscription
- remove custom monitor
- remove SNS topic
- remove Slack/chat mapping


## Remove Data Export / collection stack

AWS guidance notes that the Destination S3 bucket may need to be emptied before deleting the stack.

1. Confirm no shared export depends on it.
2. Remove the project Data Export if no longer needed.
3. Empty only project-owned S3 data if required.
4. Delete `CID-DataExports-Destination`.
5. Monitor deletion.



{{< cost >}}
Delete only what the project created. Leaving resources behind can cost money; deleting shared resources can cause a much larger incident.
{{< /cost >}}
