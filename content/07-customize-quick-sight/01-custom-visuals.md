---
title: "Customizing Quick Sight Visuals"
weight: 1
chapter: false
pre: "7.1 "
description: "Create filters, KPIs, and trend visuals from CUDOS data."
duration: "15 mins"
services:
  - Amazon Quick Sight
  - CUDOS v5
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Visuals" >}}
{{< badge "Filters" >}}
{{< duration "15 mins" >}}

# Customizing Quick Sight Visuals

## Step 1 — Create an editable analysis

Open CUDOS and use the available **Save as / Create analysis from dashboard** capability.

Name:

```text
FinOps Workshop Analysis
```

{{< note >}}
📸 **Screenshot placeholder — `07-01-save-as-analysis.png`**

Capture the CUDOS save-as/create-analysis operation.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Open the analysis editor

{{< note >}}
📸 **Screenshot placeholder — `07-02-analysis-editor.png`**

Capture the Quick Sight analysis editor.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Add a service filter

Create a filter using the service field and expose it as a control.

{{< note >}}
📸 **Screenshot placeholder — `07-03-service-filter.png`**

Capture the service filter/control configuration.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Add an account filter

Repeat for linked/source account.

{{< note >}}
📸 **Screenshot placeholder — `07-04-account-filter.png`**

Capture the account filter/control.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Create a KPI visual

Use the chosen cost metric and title it explicitly, for example:

```text
Selected Period Unblended Cost
```

{{< note >}}
📸 **Screenshot placeholder — `07-05-cost-kpi.png`**

Capture the KPI configuration and result.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Create a daily cost trend

Add a line chart:

- X axis: usage date
- Value: chosen cost metric
- Optional group: service

{{< note >}}
📸 **Screenshot placeholder — `07-06-cost-trend.png`**

Capture the finished daily cost trend visual.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 7 — Publish

Publish as:

```text
FinOps Workshop Dashboard
```

{{< note >}}
📸 **Screenshot placeholder — `07-07-published-dashboard.png`**

Capture the published custom FinOps dashboard.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< finops title="FinOps Takeaway" >}}
Customize the decision view, not the entire data model. Keep shared financial semantics consistent.
{{< /finops >}}
