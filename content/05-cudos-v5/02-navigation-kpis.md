---
title: "CUDOS KPI Contract & FinOps Finding Model"
weight: 2
chapter: false
pre: "5.2 "
description: "Define how CUDOS metrics are interpreted, attributed, reconciled, and converted into accountable FinOps findings."
services:
  - CUDOS v5
  - FinOps
  - Amazon Quick Sight
---
{{< badge "CUDOS v5" >}}
{{< badge "FinOps" >}}
{{< badge "KPIs" >}}

## Metric context

A CUDOS number is meaningful only with its analytical context:

```text
Date range and timezone
Cost metric and currency
Account/Region/service filters
Last SPICE refresh
Comparison-period definition
```

This context is retained with every finding. Otherwise, two dashboard views can show different totals while both appear correct.

## Analytical hierarchy

CUDOS supports a structured path from visibility to attribution:

```text
Selected-period spend
→ period-over-period change
→ service contribution
→ account and Region
→ usage type or resource
→ owner and workload context
```

The executive summary answers magnitude and direction. Service and account/Region views locate the financial concentration. Resource or usage-type views identify the strongest technical driver available in CUR.

## Questions answered by the product

| Analytical level | Project question |
|---|---|
| Executive | What did the selected scope cost, and how did it change? |
| Service | Which five services contributed most? |
| Account/Region | Where is the change concentrated? |
| Technical domain | Is compute, database, storage, AI/ML, or data transfer responsible? |
| Resource/usage type | Which observable driver should an owner investigate? |
| Commitment | Are discounts, RI, or Savings Plans affecting the comparison? |

## Finding contract

```text
Finding ID:
Period and timezone:
Cost metric and currency:
Current value:
Comparison value:
Absolute / percentage change:
Primary service/account/Region/usage/resource driver:
Observed evidence:
Possible cause (not yet confirmed):
Owner:
Next verification action:
Confidence: LOW / MEDIUM / HIGH
Reconciliation status:
```

Observed drivers and operational causes are deliberately separated. `EC2 cost increased in staging` can be observed from cost data; `a deployment caused the increase` remains a hypothesis until deployment or workload evidence confirms it.

## Reconciliation gate

The headline CUDOS value is compared with the Athena record from Chapter 4 using the same period, timezone, account scope, filters, currency, and cost metric.

```text
MATCH
→ the finding can proceed to interpretation.

EXPLAINED DIFFERENCE
→ retain the documented refresh or scope reason.

INVESTIGATE
→ do not select whichever number looks more plausible.
```

Common differences are SPICE lag, partial-month delivery, excluded credits/refunds, or mismatched cost metrics.

## Evidence format

One combined dashboard artifact is sufficient when it shows the period, metric, filters, headline value, and attributed driver. The financial record and reconciliation table remain the primary evidence; separate screenshots of every filter interaction add little audit value.

{{< capture src="images/05-cudos/05-01-cudos-dashboard-demo-synthetic.png" alt="CUDOS-style KPI view with scope, attributed driver, and synthetic-source reconciliation" title="CUDOS-style KPI and reconciliation demonstration" capture="Use the same published CUDOS Dashboard Demo [Synthetic] artifact from section 5.1. It must show July 2026, the $1,180.00 headline cost, AmazonEC2 as the $693.30 driver, and the Sydney Region, with a visible synthetic Direct Query source note." caption="The dashboard result reconciles to the shared Athena synthetic source. It demonstrates the review method; it is not a reconciliation claim for the real CUDOS SPICE datasets." >}}

{{< finops title="FinOps Takeaway" >}}
CUDOS creates value when it shortens the path from a reconciled financial change to the owner and technical evidence needed for a decision.
{{< /finops >}}
