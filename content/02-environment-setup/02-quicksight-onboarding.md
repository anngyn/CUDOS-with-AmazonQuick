---
title: "Quick Sight Service, Identity & Capacity Design"
weight: 2
chapter: false
pre: "2.2 "
description: "Define how Quick Sight is provisioned, owned, and sized for CUDOS rather than treating onboarding as a console exercise."
services:
  - Amazon Quick
  - Amazon Quick Sight
  - SPICE
---
{{< badge "Amazon Quick" >}}
{{< badge "Amazon Quick Sight" >}}
{{< badge "SPICE" >}}

## Role in the architecture

Quick Sight is the presentation and in-memory query layer used by CUDOS. It does not replace CUR or Athena. Its responsibility is to provide datasets, SPICE ingestion, analyses, filters, and published dashboards over approved financial semantics.

Amazon Quick is treated as a separate optional experience layer. This distinction matters because the CUDOS implementation should remain usable even when chat agents or Flows are unavailable.

## Service ownership decision

The project records four ownership choices before CUDOS deployment:

| Decision | Project value |
|---|---|
| Quick account Region | `ap-southeast-2` |
| Authentication model | Account-specific; IAM Identity Center preferred for organizational use |
| Asset owner | Named Quick Sight user or governed group |
| Administrative owner | Responsible for capacity, sharing, and lifecycle |

For a production organization, the authentication model is a governance decision because it controls offboarding, group-based access, and cross-team sharing.

## Readiness contract

The service is ready for CUDOS when all of the following are true:

- the Quick account is provisioned in the intended Region;
- the owner can access datasets, analyses, and dashboards;
- SPICE capacity is visible and sufficient for the planned CUDOS datasets;
- the identity can read the approved Athena/Glue/S3 analytical path;
- dashboard sharing is not public by default.

If any item is missing, CUDOS deployment is expected to fail or produce assets that cannot refresh. The project therefore records readiness before running `cid-cmd`, rather than diagnosing capacity and identity only after deployment.

## Cost and capacity effect

SPICE and advanced Amazon Quick capabilities can incur recurring charges. Capacity is increased only when an observed ingestion failure or measured dataset size requires it. This avoids provisioning excess capacity merely to remove uncertainty.

```text
Quick account/Region:
Asset owner:
Authentication model:
Current SPICE capacity:
Expected CUDOS datasets:
Sharing default:
Readiness status: READY / BLOCKED
```

{{< validation >}}
Quick Sight is considered a valid dependency only when ownership, Region, capacity, source access, and sharing defaults are recorded.
{{< /validation >}}
