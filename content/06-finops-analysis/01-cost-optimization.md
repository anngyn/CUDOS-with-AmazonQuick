---
title: "FinOps Cost Optimization Analysis"
weight: 1
chapter: false
pre: "6.1 "
description: "Identify evidence-backed cost movers and optimization candidates."
duration: "15 mins"
services:
  - CUDOS v5
  - FinOps
  - Cost Optimization
---
{{< badge "FinOps" >}}
{{< badge "Cost Optimization" >}}
{{< badge "CUDOS v5" >}}
{{< duration "15 mins" >}}

# FinOps Cost Optimization Analysis

## Step 1 — Choose a comparison period

Use CUDOS to compare a current period with a previous equivalent period.

{{< note >}}
📸 **Screenshot placeholder — `06-01-period-comparison.png`**

Capture the current and comparison-period configuration.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Find the largest cost mover

Identify:

- Service
- Current cost
- Previous cost
- Absolute change
- Percentage change, if available

{{< note >}}
📸 **Screenshot placeholder — `06-02-largest-cost-mover.png`**

Capture the visual or table supporting the largest cost mover.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Attribute the mover

Drill into:

- account
- Region
- usage type
- resource, when available

{{< note >}}
📸 **Screenshot placeholder — `06-03-cost-mover-driver.png`**

Capture the strongest supporting cost-driver breakdown.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Separate change from anomaly

Ask:

- Was there a planned deployment?
- Was traffic increased?
- Was a one-time fee applied?
- Did a discount or credit expire?
- Did commitment behavior change?

## Step 5 — Identify one optimization candidate

Use CUDOS recommendations or observable evidence such as:

- idle resource
- high On-Demand usage
- underused commitment
- storage inefficiency
- unusual data transfer

{{< note >}}
📸 **Screenshot placeholder — `06-04-optimization-candidate.png`**

Capture the evidence supporting the selected optimization candidate.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Write an action statement

```text
Observation:
Evidence:
Owner to contact:
Verification required:
Potential action:
```

Do not state an unverified savings amount.

{{< finops title="FinOps Takeaway" >}}
Optimization starts with evidence and ownership. A dashboard recommendation still requires workload context.
{{< /finops >}}
