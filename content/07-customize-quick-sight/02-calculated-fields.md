---
title: "Creating Custom Calculated Fields"
weight: 2
chapter: false
pre: "7.2 "
description: "Add a simple FinOps classification field and understand where BI logic should live."
duration: "15 mins"
services:
  - Amazon Quick Sight
  - Calculated Fields
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Calculated Fields" >}}
{{< badge "FinOps" >}}
{{< duration "15 mins" >}}


Calculated fields are useful for presentation-level logic. Core financial semantics should remain in a reusable semantic/query layer.

## Step 1 — Create a safe calculated field

Open the analysis and choose **Add calculated field**.

Name:

```text
Spend Band
```

Example expression:

```text
ifelse(
    {unblended_cost} >= 1000,
    'High Spend',
    'Standard'
)
```

Adapt the field name and threshold to the real dataset and workshop purpose.

{{< note >}}
📸 **Screenshot placeholder — `07-08-calculated-field-editor.png`**

Capture the calculated-field editor with the verified expression.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Use it in a visual

Create a table containing:

- service
- cost
- Spend Band

{{< note >}}
📸 **Screenshot placeholder — `07-09-spend-band-table.png`**

Capture the visual using the new calculated field.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Validate manually

Check at least two services and confirm their assigned band matches the rule.

## Step 4 — Keep core financial logic out of presentation-only fields

Avoid hiding organization-wide amortized-cost, chargeback, or allocation semantics in one Quick Sight analysis.

{{< validation >}}
The calculated field is correct for selected examples and does not redefine the underlying cost metric.
{{< /validation >}}
