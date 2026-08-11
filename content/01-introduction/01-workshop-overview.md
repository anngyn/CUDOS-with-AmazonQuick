---
title: "Business Context, Goals & Success Criteria"
weight: 1
chapter: false
pre: "1.1 "
description: "Define the business problem, project goals, scope, success criteria, and evidence model."
duration: "10 mins"
services:
  - AWS Billing
  - AWS Data Exports
  - Amazon Athena
  - Amazon Quick Sight
  - Amazon Quick
---
{{< badge "AWS Billing" >}}
{{< badge "FinOps" >}}
{{< badge "Amazon Quick" >}}


## Organizational context

The reference organization runs production, staging, and shared-service workloads on AWS. Cost information exists in AWS billing systems, but the people responsible for finance, platforms, and applications do not yet share one reproducible analytical model.

This creates predictable failure modes:

- finance sees a monthly total but cannot attribute the technical driver;
- engineering sees utilization but not the financial effect;
- dashboard users compare different metrics or time windows;
- optimization ideas are recorded without an owner or measured outcome;
- AI-generated explanations can sound plausible even when the underlying number is stale.

## Questions the project must answer

- How much are we spending?
- Which services and accounts generate the largest spend?
- How is spend changing over time?
- Which workloads can be allocated to teams, products, or cost centers?
- Which cost spikes need investigation?
- Can repetitive investigations be accelerated safely?

## Project goals

The core goal is not merely to display AWS cost. It is to create a traceable decision system:

```text
Billing record
→ reproducible metric
→ reconciled dashboard
→ attributed finding
→ accountable action
→ measured outcome
```

The AI components are an optional extension. They are useful only after the deterministic path is working.

## Success criteria

| Area | Acceptance criterion |
|---|---|
| Data foundation | CUR 2.0 reaches S3 as Parquet and is catalogued correctly |
| Reproducibility | Athena can reproduce a named CUDOS metric for the same period and scope |
| Decision support | At least one material cost mover is attributed to an owner and technical driver |
| Optimization | Proposed savings are separated from measured savings |
| Allocation | Allocation coverage is calculated with an explicit eligible-cost definition |
| Unit economics | The business denominator has a source, owner, period, and quality rule |
| Operations | An anomaly signal reaches an approved destination with an accountable response owner |
| Governance | Analytical identities cannot perform destructive workload changes |
| Lifecycle | Every project resource is deleted or explicitly retained with owner and review date |

## Scope boundary

The core system ends at CUR, Athena, CUDOS, Quick Sight, and the FinOps operating model. Amazon Quick chat agents and Flows are optional because availability, licensing, and organizational approval can vary. Their absence does not invalidate the core FinOps implementation.

## Evidence model

Evidence is retained for an **outcome**, not for every console click. The project record uses the following compact set:

| Outcome | Evidence to retain | Why it matters |
|---|---|---|
| CUR delivery | Current billing partition with at least one Parquet object | Proves that billing data reached the analytical layer |
| Athena validation | Saved SQL, result, selected database/table, period, and cost metric | Makes the number reproducible |
| CUDOS readiness | Successful dataset ingestion plus one dashboard view with filters visible | Proves the BI layer is operational |
| Financial reconciliation | Athena total versus CUDOS total for the same period and metric | Detects refresh, scope, or metric mismatches |
| FinOps finding | Baseline, cost driver, owner, proposed action, and verification method | Converts visibility into accountable work |
| Allocation or unit economics | Coverage formula or business denominator and its source | Connects cloud cost to ownership or value |
| Alerting | Monitor/subscription configuration and one supported delivery test | Proves that the operating loop works |
| Cleanup | Resource inventory showing deleted and intentionally retained resources | Prevents project spend from becoming waste |

Screenshots are optional unless they prove one of these outcomes. Prefer a small result table, saved SQL, or resource inventory when it is easier to audit than an image.

## Design principles

### Evidence before AI

```text
Billing data → deterministic metric → validation → AI explanation
```

### Visibility before optimization

Understand **what changed, where, and who owns it** before recommending a change.

### Human review before remediation

This project does not give an AI agent unrestricted permission to terminate instances, delete databases, change IAM, or purchase commitments.

{{< validation >}}
The project scope is coherent when every reported cost can be traced to a metric, period, filter set, data refresh, and authoritative source.
{{< /validation >}}

{{< finops title="FinOps Takeaway" >}}
FinOps is not simply cost cutting. It creates shared financial accountability between engineering, finance, product, and leadership.
{{< /finops >}}
