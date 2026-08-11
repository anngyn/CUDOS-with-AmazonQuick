---
title: "Automation Levels, Approval & Remediation Boundary"
weight: 2
chapter: false
pre: "9.2 "
description: "Define which FinOps activities may be automated and where human-owned workload authority begins."
services:
  - Amazon Quick
  - AWS IAM
  - FinOps Governance
---
{{< badge "Governance" >}}
{{< badge "Human Review" >}}
{{< badge "FinOps" >}}

## Automation taxonomy

| Level | Capability | Project status |
|---|---|---|
| 0 | Manual analysis | Supported |
| 1 | Automated detection | Designed through Cost Anomaly Detection |
| 2 | Automated investigation | Evaluated Amazon Quick Flow run with synthetic data; draft and optional |
| 3 | Automated recommendation | Optional, always reviewable |
| 4 | Human-approved workload action | Outside the analytical agent |

The project targets Levels 1–3. Level 4 belongs to the workload owner’s delivery process, where change windows, testing, rollback, and business risk are available.

## Prohibited agent authority

The analytical identity cannot directly:

- terminate EC2 instances;
- stop or delete RDS databases;
- delete S3 data;
- change IAM;
- purchase Savings Plans or Reserved Instances.

These are not merely prompt restrictions. IAM and tool configuration enforce the boundary.

## Approval package

```text
Observed evidence:
Financial impact:
Affected scope:
Proposed action:
Verification required:
Owner:
Risk and rollback:
Approval status:
```

The final recommendation carries:

```text
Status: REVIEW REQUIRED
No workload changes have been executed.
```

## Separation of security domains

```text
Analytical domain
→ detection, query, explanation, recommendation

Workload domain
→ approved change, deployment control, rollback, measurement
```

This separation prevents a cost-analysis compromise from becoming a workload-management incident.

{{< security >}}
Prompt language communicates the policy; IAM and tool permissions enforce it.
{{< /security >}}
