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

{{< capture src="images/06-finops-analysis/06-02-allocation-unit-economics.png" alt="Allocation coverage and unit-cost result with governed denominator" title="Allocation coverage and unit economics" capture="Capture a result that shows the ownership dimension, eligible-cost total, allocated and unallocated cost, coverage percentage, business denominator, reporting period, and calculated unit cost. The financial period and business-volume period must match." caption="The image supports the allocation result; the taxonomy and denominator contracts remain authoritative." >}}

## Current project status

The allocation and denominator contracts are defined, but a real ownership taxonomy, eligible-cost total, coverage result, and business-volume source have not yet been supplied. Unit economics remains pending until both financial and business evidence are available.

{{< finops title="FinOps Takeaway" >}}
Allocation connects cost to accountability. Unit economics connects that accountable cost to delivered value.
{{< /finops >}}
