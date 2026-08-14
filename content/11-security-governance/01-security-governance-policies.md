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

## Access matrix: live technical review

The following is a read-only configuration and resource-permission review run in `ap-southeast-2` on 14 August 2026. Principal names are intentionally not published.

| Asset | Observed access or control | Public-sharing signal reviewed | Result |
|---|---|---|---|
| Data Exports S3 | `AES256`; all four S3 Block Public Access controls enabled | S3 public bucket policies and ACL access are blocked by these controls | PASS for reviewed controls |
| Athena-results S3 | `AES256`; all four S3 Block Public Access controls enabled | S3 public bucket policies and ACL access are blocked by these controls | PASS for reviewed controls |
| Athena `primary` | Workgroup configuration enforced; query results use `SSE_S3` | Not applicable to a QuickSight sharing review | PASS for reviewed controls |
| Five deployed QuickSight dashboards | One explicit principal per dashboard | No namespace-wide, anonymous, or public-like principal detected in `DashboardPermissions` | PASS for resource permissions reviewed |
| FinOps Q&A Topic [Synthetic] | One explicit principal | No namespace-wide, anonymous, or public-like principal detected in `TopicPermissions` | PASS for resource permissions reviewed |

This does not certify every account-level sharing, embedding, IAM, or organisation control. It proves the listed resource-level signals at the recorded time.

[Download the machine-readable access-governance audit](/data/audits/11-01-access-governance-audit.json)

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

The technical boundary is evidenced by the live audit in sections 11.1 and 11.2. The remaining governance work is business-owned: record the named data, dashboard, metric, workload, and security owners; set the next review date; and retain the signed access-review record. These assignments are deliberately not inferred from a temporary AWS session.

{{< finops title="FinOps Takeaway" >}}
Governance turns cost visibility into accountable decisions without giving the analytical platform unnecessary workload authority.
{{< /finops >}}
