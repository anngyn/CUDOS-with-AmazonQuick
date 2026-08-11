---
title: "Presentation Logic & Calculated-Field Boundary"
weight: 2
chapter: false
pre: "7.2 "
description: "Separate harmless presentation classifications from organization-wide financial semantics."
services:
  - Amazon Quick Sight
  - Calculated Fields
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Calculated Fields" >}}
{{< badge "Semantic Governance" >}}

## Boundary decision

Quick Sight calculated fields are appropriate for local presentation logic. They are not the correct location for shared definitions of amortized cost, chargeback, allocation, or commitment treatment because those definitions would be hidden inside one analysis.

```text
Reusable financial meaning
→ Athena view or governed semantic layer

Local visual classification
→ Quick Sight calculated field
```

## Reference classification

`Spend Band` is intentionally simple:

```text
ifelse(
    {net_unblended_cost} >= 15,
    'High Spend',
    'Standard Spend'
)
```

The `$15` threshold and source field are documented. In the synthetic demonstration, the production EC2 daily row is above the threshold while RDS, Lambda, S3, data transfer, and staging rows are below it. The field classifies a value for the current view; it does not redefine the cost metric.

## Validation

At least two rows on opposite sides of the threshold are checked manually. The validation record contains the input value, expected band, observed band, and result.

```text
Calculated field:
Source field:
Threshold/version:
Test case 1:
Test case 2:
Result: PASS / FAIL
```

{{< capture src="images/07-customize-quick-sight/07-01-finops-decision-dashboard.png" alt="QuickSight Spend Band validation with values on both sides of the threshold" title="Calculated-field boundary validation" capture="Use the same FinOps Decision Dashboard [Synthetic] artifact from section 7.1. Its scope table shows at least one $15-or-more production EC2 row labeled High Spend and lower-cost rows labeled Standard Spend. Do not use the calculated-field editor as evidence." caption="The two bands demonstrate the local presentation rule without treating it as a shared financial definition." >}}

{{< validation >}}
Presentation logic is accepted when it is transparent, locally scoped, manually testable, and does not override the governed financial model.
{{< /validation >}}
