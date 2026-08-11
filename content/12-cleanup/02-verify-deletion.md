---
title: "Lifecycle Verification & Residual Cost Check"
weight: 2
chapter: false
pre: "12.2 "
description: "Reconcile the final resource inventory and check delayed billing for residual project cost."
duration: "5–10 mins"
services:
  - AWS CloudFormation
  - Amazon S3
  - Amazon Quick
  - AWS Billing
---
{{< badge "Validation" >}}
{{< badge "Cleanup" >}}
{{< badge "FinOps" >}}


Deletion commands are not proof of lifecycle completion. The final state is reconciled across control planes and revisited after billing data has caught up.


## Verify CloudFormation

Confirm the project Data Exports stack is no longer active.


## Verify Data Exports

Confirm the project export is gone if you intended to remove it.


## Verify S3 and Glue

Check that project-owned S3 and Glue resources are removed or intentionally retained.

## Verify Quick assets

Check:

- Spaces
- Chat agents
- Flows
- Datasets
- Analyses
- Dashboards
- SPICE capacity/usage


## Verify alert resources

Check:

- Cost Anomaly Detection subscription/monitor
- SNS topic
- Slack/chat mapping

## Document anything retained

```text
Resource:
Reason retained:
Owner:
Expected recurring cost:
Next review date:
```

Use one final inventory as the cleanup evidence. It should list every project-created resource with status `DELETED` or `RETAINED`, rather than separate screenshots for each service console.

## Current retained inventory

The project is intentionally still retained while its evidence is being reviewed. A live read-only inventory on 12 August 2026 confirmed the following status:

| Asset group | Live evidence | Status | Owner | Reason / next review |
|---|---|---|---|---|
| Data foundation | `CID-DataExports-Destination` is `CREATE_COMPLETE`; core Athena/Glue resources exist | RETAINED | Project owner | CUDOS foundation; review 2026-09-01 |
| Quick dashboards, analyses, datasets | CUDOS v5 and custom CUDOS/FinOps assets are listed | RETAINED | Project owner | Project evidence and Direct Query analytics; review 2026-09-01 |
| Q&amp;A and Flow | Synthetic Q&amp;A Topic is indexed; governed Flow remains Draft with exported report | RETAINED | Project owner | Sections 8–9 evidence; review 2026-09-01 |
| Alerting | Service monitor, `$10` immediate subscription, and SNS topic exist; no delivery endpoint | RETAINED | Project owner | Detector learning and routing pending; review 2026-09-01 |

Expected recurring cost is not represented as zero: S3 storage/requests, Athena scans, Amazon Quick entitlement, and any future SNS delivery remain subject to the applicable AWS pricing. No delete command has been authorized or run.

{{< capture src="images/12-cleanup/12-01-final-resource-inventory.svg" alt="Sanitized live project resource inventory with retained status" title="Pre-teardown resource inventory" capture="Sanitized live CLI inventory showing the project-created foundation, Amazon Quick assets, anomaly monitor, and SNS topic. All entries are explicitly RETAINED because teardown has not been authorized." caption="This is a pre-teardown inventory, not deletion evidence. It replaces scattered console screenshots while preserving the retain-or-delete decision." >}}

[Download the machine-readable retained inventory](/data/audits/12-01-retained-resource-inventory.json)

## Review future billing

Cost systems are not real-time. Revisit billing later to make sure no unexpected project resource continues generating spend.

{{< validation >}}
Lifecycle documentation is complete when every created resource is either removed or explicitly documented as intentionally retained. Actual teardown remains incomplete until the owner authorizes it and a post-delete inventory confirms the final state.
{{< /validation >}}

{{< finops title="FinOps Takeaway" >}}
Lifecycle management is FinOps. “Who owns this resource and why does it still exist?” is a cost-optimization question.
{{< /finops >}}
