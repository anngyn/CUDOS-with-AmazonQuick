---
title: "CUDOS Dashboard Navigation & KPIs"
weight: 2
chapter: false
pre: "5.2 "
description: "Explore CUDOS through practical FinOps questions."
duration: "15 mins"
services:
  - CUDOS v5
  - FinOps
  - Amazon Quick Sight
---
{{< badge "CUDOS v5" >}}
{{< badge "FinOps" >}}
{{< badge "KPIs" >}}
{{< duration "15 mins" >}}


Exact sheet labels can change between CUDOS releases, so use the deployed dashboard as the source of truth.

## Step 1 — Set the time context

Choose a recent period that contains real billing data.

Record:

- selected date range
- selected cost metric
- active filters

{{< note >}}
📸 **Screenshot placeholder — `05-08-cudos-date-filter.png`**

Capture the date and cost-metric context used in the rest of the lab.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Read the executive summary

Answer:

1. What is selected-period spend?
2. What is the period-over-period direction?
3. Which service contributes most?
4. Are discounts, credits, RI, or Savings Plans visible?

{{< note >}}
📸 **Screenshot placeholder — `05-09-cudos-executive.png`**

Capture the executive summary and key KPIs.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Analyze service spend

Identify the top five services.

{{< note >}}
📸 **Screenshot placeholder — `05-10-cudos-service-breakdown.png`**

Capture the top-service breakdown.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Analyze account and Region

Apply account and Region filters.

Answer:

- Which account has the highest spend?
- Which Region has the highest spend?
- Does filtering change the dominant service?

{{< note >}}
📸 **Screenshot placeholder — `05-11-cudos-account-region.png`**

Capture an account or Region breakdown.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Explore a technical domain

Choose one:

- Compute
- Databases
- Storage
- AI/ML
- Data Transfer

Perform one drill-down to resource or usage-type level where supported.

{{< note >}}
📸 **Screenshot placeholder — `05-12-cudos-resource-drilldown.png`**

Capture one useful resource-level or usage-level drill-down.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Record a FinOps finding

Write one evidence-based observation and keep causal explanations separate until they are verified.

{{< finops title="FinOps Takeaway" >}}
CUDOS turns raw cost records into a navigation path: total spend → service/account/Region → resource or usage driver.
{{< /finops >}}
