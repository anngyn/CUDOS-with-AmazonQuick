---
title: "Unit Economics & Allocation Breakdown"
weight: 2
chapter: false
pre: "6.2 "
description: "Use allocation dimensions and business denominators to make cloud cost accountable."
duration: "15 mins"
services:
  - CUR 2.0
  - Cost Allocation Tags
  - Cost Categories
  - FinOps
---
{{< badge "Unit Economics" >}}
{{< badge "Cost Allocation" >}}
{{< badge "FinOps" >}}
{{< duration "15 mins" >}}

# Unit Economics & Allocation Breakdown

## Step 1 — Inspect available allocation metadata

Determine which exist:

- linked/source account
- Cost Categories
- cost allocation tags
- account taxonomy
- team/project/product tags

{{< note >}}
📸 **Screenshot placeholder — `06-05-allocation-metadata.png`**

Capture the available allocation dimensions.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Choose one ownership dimension

Use a meaningful real dimension such as:

```text
Team
Cost Center
Environment
Application
Linked Account
```

Create a cost breakdown by that dimension.

{{< note >}}
📸 **Screenshot placeholder — `06-06-cost-by-owner.png`**

Capture the cost breakdown by the selected ownership dimension.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Identify unallocated spend

Look for null, blank, unknown, or uncategorized values.

Document the rule:

```text
Allocated = a recognized ownership tag or Cost Category is present
```

{{< note >}}
📸 **Screenshot placeholder — `06-07-unallocated-spend.png`**

Capture allocated versus unallocated spend.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Define a unit-economics candidate

Examples:

```text
AWS cost / API requests
AWS cost / active users
AWS cost / orders
AWS cost / inference requests
AWS cost / tenant
```

Choose one workload and document where the denominator would come from.

## Step 5 — State the limitation

Do not invent unit economics when the denominator is unavailable.

```text
Cloud cost + business metric = unit economics
```

{{< finops title="FinOps Takeaway" >}}
Allocation answers “who owns the cost?” Unit economics answers “what value did the cost produce?”
{{< /finops >}}
