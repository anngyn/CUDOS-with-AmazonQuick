---
title: "Quick Sight Decision View Design"
weight: 1
chapter: false
pre: "7.1 "
description: "Design a focused FinOps decision view without rebuilding the CUDOS semantic model."
services:
  - Amazon Quick Sight
  - CUDOS v5
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Visual Design" >}}
{{< badge "FinOps" >}}

## Product intent

CUDOS provides broad AWS cost intelligence. The custom Quick Sight analysis narrows that model to one recurring decision rather than duplicating the entire dashboard.

The reference decision view answers:

```text
What did the selected scope cost?
How is that cost changing daily?
Which service and account filters explain the view?
When was the data last refreshed?
```

## Visual contract

The analysis is created from the approved CUDOS dataset and published as `FinOps Project Dashboard`. Its minimum visual contract is:

| Element | Purpose |
|---|---|
| Date control | Defines the financial period explicitly |
| Cost metric label | Prevents unblended/amortized/net ambiguity |
| Service filter | Supports product/service attribution |
| Account filter | Supports ownership and environment attribution |
| KPI | Shows selected-period cost |
| Daily trend | Shows direction and timing of change |
| Refresh timestamp | Exposes data freshness |

## Design choices

The KPI title includes the financial metric, for example `Selected Period Unblended Cost`. A generic title such as `Total Cost` is rejected because it hides metric semantics.

The trend uses usage date on the x-axis and the same cost metric as the KPI. Optional service grouping is applied only when the resulting series remain readable.

Filters are visible in the published view so another reviewer can reproduce the same number.

## Asset record

```text
Dashboard:
Source dataset:
Cost metric:
Date field/timezone:
Filters and defaults:
Refresh status/time:
Owner:
```

One final dashboard artifact is retained when it shows this context together. Screenshots of individual filter configuration screens are not project evidence.

{{< capture src="images/07-customize-quick-sight/07-01-finops-decision-dashboard.png" alt="Published QuickSight FinOps decision dashboard with scope and freshness context" title="Published FinOps decision view" capture="Capture the final published dashboard with the date control, named cost metric, service and account filters, selected-period KPI, daily trend, and last-refresh timestamp visible in one view." caption="The final decision view is retained; filter-setup and visual-formatting screens are intentionally omitted." >}}

{{< finops title="FinOps Takeaway" >}}
The custom view adds decision focus while preserving shared CUDOS financial semantics.
{{< /finops >}}
