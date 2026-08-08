---
title: "Automated Governance & Remediation"
weight: 2
chapter: false
pre: "9.2 "
description: "Add human approval boundaries to agentic FinOps recommendations."
duration: "10 mins"
services:
  - Amazon Quick
  - AWS IAM
  - FinOps Governance
---
{{< badge "Governance" >}}
{{< badge "Human Review" >}}
{{< badge "FinOps" >}}
{{< duration "10 mins" >}}


## Step 1 — Classify automation levels

| Level | Capability |
|---|---|
| 0 | Manual analysis |
| 1 | Automated detection |
| 2 | Automated investigation |
| 3 | Automated recommendation |
| 4 | Human-approved workload action |

The workshop implements Levels 1–3.

## Step 2 — Identify risky actions

Ensure the Flow does not directly:

- terminate EC2
- stop/delete RDS
- delete S3 data
- change IAM
- purchase Savings Plans or RIs

{{< note >}}
📸 **Screenshot placeholder — `09-06-flow-action-review.png`**

Capture the Flow showing analysis/recommendation steps and no destructive AWS action.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Define an approval package

```text
Observed evidence
Financial impact
Affected scope
Proposed action
Verification required
Owner
Risk
Approval status
```

## Step 4 — Add a human-review message

Finish the Flow output with:

```text
Status: REVIEW REQUIRED
No workload changes have been executed.
```

{{< note >}}
📸 **Screenshot placeholder — `09-07-review-required-output.png`**

Capture the final output showing human review is required.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Map governance to IAM

The analytical agent/Flow does not need direct destructive EC2/RDS permissions.

{{< security >}}
Recommendation generation and resource modification are separate security domains.
{{< /security >}}
