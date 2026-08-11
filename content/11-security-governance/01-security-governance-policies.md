---
title: "FinOps Operating Model & Access Governance"
weight: 1
chapter: false
pre: "11.1 "
description: "Define data ownership, dashboard sharing, review cadence, and accountability around the FinOps platform."
services:
  - Amazon Quick
  - Amazon S3
  - FinOps Governance
---
{{< badge "Security" >}}
{{< badge "Operating Model" >}}
{{< badge "FinOps" >}}

## Governance objective

The platform creates visibility, but visibility changes behavior only when access, ownership, review cadence, and decision authority are explicit.

## Access matrix

| Asset | Read principals | Admin/owner | Public sharing | Review result |
|---|---|---|---|---|
| Data Exports S3 |  |  | disabled | PASS/FAIL |
| Glue/Athena |  |  | n/a | PASS/FAIL |
| CUDOS/Quick Sight |  |  | disabled | PASS/FAIL |
| Quick Space/agent |  |  | disabled | PASS/FAIL |

Role and group names are recorded; credentials and temporary sessions are not.

## Ownership model

```text
FinOps data owner:
Dashboard product owner:
Metric/semantic owner:
Optimization review owner:
Workload action owner:
Security owner:
```

The dashboard owner maintains the analytical product. The workload owner approves operational changes. Combining these responsibilities would allow a dashboard recommendation to become an uncontrolled infrastructure action.

## Review cadence

```text
Daily     anomaly queue and notification health
Weekly    material cost movers and investigation backlog
Monthly   allocation coverage, commitments, and realized savings
Quarterly access review, metric definitions, and retained resources
```

The cadence is tied to artifacts: anomaly record, finding backlog, allocation report, savings measurement, and access matrix.

## Governance rules

- every financial claim includes period, metric, scope, and freshness;
- every recommendation has an owner and verification requirement;
- unallocated spend is measured rather than hidden;
- AI output does not bypass approval;
- public sharing is disabled unless explicitly reviewed;
- proposed savings and realized savings are reported separately;
- retained project resources have an owner and next review date.

## Current project status

The operating model and matrix are defined. Real principals, owners, review dates, and completed access-review results remain to be populated.

{{< finops title="FinOps Takeaway" >}}
Governance turns cost visibility into accountable decisions without giving the analytical platform unnecessary workload authority.
{{< /finops >}}
