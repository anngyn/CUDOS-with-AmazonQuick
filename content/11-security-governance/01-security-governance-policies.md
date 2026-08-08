---
title: "Security & Governance Policies"
weight: 1
chapter: false
pre: "11.1 "
description: "Review data access, dashboard sharing, ownership, and human-review controls."
duration: "10 mins"
services:
  - Amazon Quick
  - Amazon S3
  - FinOps Governance
---
{{< badge "Security" >}}
{{< badge "Governance" >}}
{{< badge "Amazon Quick" >}}
{{< duration "10 mins" >}}


## Step 1 — Review billing-data access

Identify who can access:

- Data Exports S3 bucket
- Glue database
- Athena query results
- CUDOS dashboard
- custom Quick Sight dashboard
- Quick Space and agent

{{< note >}}
📸 **Screenshot placeholder — `11-01-data-access-review.png`**

Capture the relevant access configuration without exposing sensitive principal details.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Review dashboard sharing

In Quick Sight, inspect sharing for CUDOS and the custom dashboard.

{{< note >}}
📸 **Screenshot placeholder — `11-02-dashboard-sharing.png`**

Capture the dashboard sharing configuration.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Review the FinOps Space

Inspect:

- members
- linked dashboards
- linked resources
- agent access

{{< note >}}
📸 **Screenshot placeholder — `11-03-space-sharing.png`**

Capture the Space membership/resource view.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Define ownership

```text
FinOps data owner:
Dashboard owner:
Optimization review owner:
Security owner:
```

## Step 5 — Define review cadence

Example:

```text
Daily: anomaly alerts
Weekly: material cost movers
Monthly: allocation coverage + commitments + optimization backlog
```

## Step 6 — Define governance rules

- every recommendation has an owner
- financial claims are evidence-backed
- unallocated spend is tracked
- AI recommendations do not bypass approval
- workshop cost data is not public

{{< finops title="FinOps Takeaway" >}}
Governance connects visibility to ownership. A dashboard without an operating process rarely changes behavior.
{{< /finops >}}
