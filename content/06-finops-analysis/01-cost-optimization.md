---
title: "Optimization Finding: From Cost Change to Measured Outcome"
weight: 1
chapter: false
pre: "6.1 "
description: "Turn a reconciled cost change into an attributed, approved, and measured FinOps outcome."
services:
  - CUDOS v5
  - FinOps
  - Cost Optimization
---
{{< badge "FinOps" >}}
{{< badge "Cost Optimization" >}}
{{< badge "CUDOS v5" >}}

## Operating model

Optimization is treated as a controlled lifecycle rather than a dashboard recommendation:

{{< evidence src="images/06-finops-analysis/06-01-evidence-driven-finops-operating-loop.png" alt="Evidence-driven FinOps operating loop from anomaly detection through validation, attribution, governance, action, and measurement" caption="This is the project operating model, not the deployment architecture. It separates recommendation, approval, execution, and realized savings." >}}

```text
Detect change
→ validate the number
→ attribute the driver
→ assign an owner
→ evaluate risk
→ approve or reject
→ execute outside the analytical identity
→ measure the result
```

## Materiality model

Equivalent current and previous periods are compared using the same metric and scope:

```text
Absolute change = current cost - previous cost
Percentage change = absolute change / previous cost × 100
```

When previous cost is zero, percentage change is `N/A`; the absolute change remains valid. Both values matter because a large percentage on a tiny baseline may not be operationally material.

## Attribution model

The largest material mover is decomposed through available CUR dimensions:

```text
Service
→ account
→ Region
→ usage type
→ resource
→ workload owner
```

Attribution identifies where cost changed. It does not prove why. Planned deployment, traffic growth, one-time fees, expired credits, or commitment changes require workload or business evidence.

## Candidate decision record

Candidates can originate from idle resources, On-Demand concentration, underused commitments, storage inefficiency, or unusual data transfer. Each candidate is recorded before action:

```text
Finding ID:
Observation:
Reconciled evidence:
Owner:
Operational cause confirmed:
Verification required:
Proposed action:
Expected-savings method:
Risk and rollback:
Approval status: PROPOSED / APPROVED / REJECTED
```

Expected savings are a forecast, not a result. They remain clearly labeled until measured.

## Outcome measurement

After an approved action, an equivalent post-action period is compared with the baseline and adjusted for material demand changes where possible:

```text
Action date:
Baseline period and cost:
Measurement period and cost:
Demand adjustment:
Estimated savings before action:
Measured savings after action:
Unexpected side effects:
Status: VALIDATED / INCONCLUSIVE / ROLLED BACK
```

Concrete cause and effect:

```text
Staging compute cost increases
→ resource usage shows instances running overnight
→ owner confirms no overnight requirement
→ schedule change is approved with rollback
→ equivalent next period is measured
→ only the measured reduction is reported as realized savings
```

{{< capture src="images/06-finops-analysis/06-01-optimization-outcome-mock.png" alt="Amazon Quick demonstration dashboard comparing baseline and measurement-period costs for a FinOps optimization outcome" title="Demonstration optimization outcome" capture="Capture the published Amazon Quick dashboard showing the daily baseline and measurement trends, realized savings by service and Region, validated outcome status, and the baseline-to-measurement comparison." caption="Demonstration dataset: the dashboard uses an isolated Athena Direct Query view to illustrate the measurement workflow. The $42 baseline, $27 measurement cost, and $15 savings are synthetic scenario values, not realized savings from the project's CUR 2.0 data." >}}

## Current project status

The project now includes a working Amazon Quick demonstration of the complete measurement pattern: daily baseline and measurement trends, service and Region attribution, outcome status, and a summarized savings result. It runs through an isolated Athena Direct Query view so it does not consume the unavailable SPICE capacity or modify the CUDOS datasets. Because the current CUR 2.0 history is not sufficient for a comparable before-and-after period, the displayed $15 reduction remains a synthetic case-study result rather than a realized AWS billing claim.

{{< finops title="FinOps Takeaway" >}}
A recommendation becomes a FinOps outcome only after ownership, approval, implementation, and comparable measurement.
{{< /finops >}}
