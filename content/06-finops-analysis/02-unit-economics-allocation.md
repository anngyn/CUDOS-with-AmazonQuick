---
title: "Allocation Coverage & Unit Economics Model"
weight: 2
chapter: false
pre: "6.2 "
description: "Define ownership coverage and connect allocated cloud cost to a governed business denominator."
services:
  - CUR 2.0
  - Cost Allocation Tags
  - Cost Categories
  - FinOps
---
{{< badge "Unit Economics" >}}
{{< badge "Cost Allocation" >}}
{{< badge "FinOps" >}}

## Ownership model

Allocation answers who is accountable for cost. The available hierarchy can combine linked account, Cost Categories, cost allocation tags, account taxonomy, team, product, application, and environment.

One canonical ownership dimension is selected for reporting. Mixing `Team`, `CostCenter`, and `Application` without precedence rules would allow the same charge to be attributed differently by different reports.

```text
Primary ownership dimension:
Fallback dimension:
Recognized values:
Unknown/unallocated value:
Taxonomy owner:
Review cadence:
```

## Coverage definition

The project distinguishes eligible cost from all billing rows. Tax, support, credits, or centrally managed shared services may be excluded, but every exclusion is explicit.

```text
Allocated = a recognized ownership tag or Cost Category is present

Allocation coverage %
= allocated eligible cost / total eligible cost × 100

Unallocated cost
= total eligible cost - allocated eligible cost
```

Without an eligible-cost definition, two teams can produce different coverage percentages from the same CUR table.

## Shared-cost treatment

Shared services are not silently forced into a product team. The project chooses one documented treatment:

- retain as a central platform cost;
- allocate using a measured driver;
- split using an approved fixed rule;
- leave unallocated and track it as a data-quality backlog.

The allocation rule, owner, effective date, and rationale are versioned because changing the rule changes historical accountability.

## Unit-economics contract

Unit economics combines allocated cloud cost with a verified business metric:

```text
Unit cost = allocated workload cost / verified business volume
```

The denominator has its own contract:

```text
Business metric:
Source system/table:
Owner:
Aggregation period and timezone:
Refresh frequency:
Join key or allocation rule:
Quality rule:
Known exclusions:
```

Example:

```text
Monthly inference workload cost = $1,200
Verified successful inference requests = 600,000
Cost per 1,000 successful requests = $2.00
```

The example demonstrates the formula only; it is not a measured project result. Using total API attempts when the business definition requires successful requests would make efficiency appear better as failures increase.

{{< capture src="images/06-finops-analysis/06-02-allocation-unit-economics.png" alt="Amazon Quick synthetic dashboard showing allocation coverage, allocated and unallocated cost, owner attribution, and cost per 1,000 requests" title="Allocation coverage and unit economics demonstration" capture="Open the published FinOps Allocation and Unit Economics [Synthetic] dashboard. Capture the $2.00 cost per 1,000 requests, 96.85 allocation coverage, owner-cost bar chart, allocated-versus-unallocated donut, and the summary table. Keep the synthetic Direct Query label visible." caption="Demonstration dataset: the allocation and business denominator are derived from the same synthetic cost source used by the CUDOS-style dashboard and the 6.1 optimization outcome." >}}

## Current project status

The project includes a working Amazon Quick Direct Query demonstration based on the shared synthetic source: `$1,180.00` eligible cost, `$1,142.80` allocated cost, `$37.20` unallocated cost, `96.85%` allocation coverage, and `$2.00` per 1,000 successful inference requests. The production ownership taxonomy and business-volume source remain pending; these synthetic values demonstrate the governed calculation path rather than claim real AWS allocation results.

{{< finops title="FinOps Takeaway" >}}
Allocation connects cost to accountability. Unit economics connects that accountable cost to delivered value.
{{< /finops >}}
