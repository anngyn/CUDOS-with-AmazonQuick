---
title: "Deploy CUDOS v5 Dashboards"
weight: 1
chapter: false
pre: "<b>5.1 </b>"
description: "Deploy Cloud Intelligence Dashboards (CUDOS v5) in Amazon QuickSight."
duration: "30 mins"
services:
  - Amazon QuickSight
  - CUDOS v5
---

# Deploy CUDOS v5 Dashboards

{{< badge "Amazon QuickSight" >}} {{< badge "CUDOS v5" >}}
{{< duration "30 mins" >}}

CUDOS v5 provides pre-built executive and operational dashboards that visualize cost efficiency, reservation coverage, and savings opportunities.

## Step 1 — Verify QuickSight Subscription

Ensure Amazon QuickSight is onboarded in your AWS account and has permissions to access the S3 billing bucket and Athena.

## Step 2 — Deploy CUDOS Dashboard Template

Use the CID CLI tool or CloudFormation template to deploy CUDOS v5:

```bash
pip install cid-cmd
cid-cmd deploy --dashboard cudos
```

{{< validation >}}
Verify that the CUDOS v5 dashboard is visible in Amazon QuickSight under **Dashboards**.
{{< /validation >}}
