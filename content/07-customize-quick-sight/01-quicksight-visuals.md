---
title: "Customizing QuickSight Visuals"
weight: 1
chapter: false
pre: "<b>7.1 </b>"
description: "Create custom visuals, calculated fields, and KPI cards in QuickSight."
duration: "20 mins"
services:
  - Amazon QuickSight
---

{{< badge "Amazon QuickSight" >}}
{{< duration "20 mins" >}}

Customize your CUDOS dashboards by adding business-specific KPIs and calculated fields.

## Step 1 — Create a Calculated Field

In QuickSight dataset edit mode, add a new calculated field for **Daily Average Spend**:

```text
sum(line_item_unblended_cost) / countDistinct(line_item_usage_start_date)
```

## Step 2 — Add KPI Visual

Add a KPI visual to your dashboard showing month-over-month cost variance.
