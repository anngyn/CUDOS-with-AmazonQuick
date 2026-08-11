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
    {unblended_cost} >= 1000,
    'High Spend',
    'Standard'
)
```

The threshold and source field are documented. The field classifies a value for the current view; it does not redefine the cost metric.

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

{{< capture src="images/07-customize-quick-sight/07-02-spend-band-validation.png" alt="QuickSight Spend Band validation with values on both sides of the threshold" title="Calculated-field boundary validation" capture="Capture a small table visual showing at least one input below the threshold and one input at or above it, with the observed Spend Band and expected result visible. Do not use the calculated-field editor as the evidence." caption="Two boundary cases demonstrate the presentation rule without treating it as a shared financial definition." >}}

{{< validation >}}
Presentation logic is accepted when it is transparent, locally scoped, manually testable, and does not override the governed financial model.
{{< /validation >}}
