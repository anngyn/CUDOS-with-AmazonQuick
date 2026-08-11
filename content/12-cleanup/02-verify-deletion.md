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

{{< capture src="images/12-cleanup/12-01-final-resource-inventory.png" alt="Final project resource inventory with deleted and retained status" title="Final lifecycle inventory" capture="Capture the reconciled resource inventory showing every project-created stack, export, bucket or retained data prefix, Glue/Athena asset, Quick asset, anomaly monitor, SNS topic, and chat mapping with status DELETED or RETAINED, owner, reason, and expected recurring cost." caption="One lifecycle inventory replaces separate deletion screenshots from every AWS console." >}}

## Review future billing

Cost systems are not real-time. Revisit billing later to make sure no unexpected project resource continues generating spend.

{{< validation >}}
The project is complete when every created resource is either removed or explicitly documented as intentionally retained.
{{< /validation >}}

{{< finops title="FinOps Takeaway" >}}
Lifecycle management is FinOps. “Who owns this resource and why does it still exist?” is a cost-optimization question.
{{< /finops >}}
