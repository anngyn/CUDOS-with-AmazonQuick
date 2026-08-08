---
title: "Verifying Complete Resource Deletion"
weight: 2
chapter: false
pre: "12.2 "
description: "Verify that no unintended workshop resources remain."
duration: "5–10 mins"
services:
  - AWS CloudFormation
  - Amazon S3
  - Amazon Quick
  - AWS Billing
---
{{< badge "Validation" >}}
{{< badge "Cleanup" >}}
{{< badge "FinOps" >}}
{{< duration "5–10 mins" >}}


## Step 1 — Verify CloudFormation

Confirm the workshop Data Exports stack is no longer active.

{{< note >}}
📸 **Screenshot placeholder — `12-07-cloudformation-final.png`**

Capture the final CloudFormation state.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Verify Data Exports

Confirm the workshop export is gone if you intended to remove it.

{{< note >}}
📸 **Screenshot placeholder — `12-08-data-exports-final.png`**

Capture the final Data Exports list.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Verify S3 and Glue

Check that workshop-owned S3 and Glue resources are removed or intentionally retained.

## Step 4 — Verify Quick assets

Check:

- Spaces
- Chat agents
- Flows
- Datasets
- Analyses
- Dashboards
- SPICE capacity/usage

{{< note >}}
📸 **Screenshot placeholder — `12-09-quick-final.png`**

Capture the Quick/Quick Sight state after cleanup.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Verify alert resources

Check:

- Cost Anomaly Detection subscription/monitor
- SNS topic
- Slack/chat mapping

## Step 6 — Document anything retained

```text
Resource:
Reason retained:
Owner:
Expected recurring cost:
Next review date:
```

## Step 7 — Review future billing

Cost systems are not real-time. Revisit billing later to make sure no unexpected workshop resource continues generating spend.

{{< validation >}}
The workshop is complete when every created resource is either removed or explicitly documented as intentionally retained.
{{< /validation >}}

{{< finops title="FinOps Takeaway" >}}
Lifecycle management is FinOps. “Who owns this resource and why does it still exist?” is a cost-optimization question.
{{< /finops >}}
