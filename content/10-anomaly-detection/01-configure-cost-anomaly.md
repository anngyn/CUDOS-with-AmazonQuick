---
title: "Configuring AWS Cost Anomaly Detection"
weight: 1
chapter: false
pre: "10.1 "
description: "Create a cost monitor and alert subscription using AWS Cost Anomaly Detection."
duration: "15 mins"
services:
  - AWS Cost Anomaly Detection
  - AWS Cost Explorer
---
{{< badge "AWS Cost Anomaly Detection" >}}
{{< badge "AWS Cost Explorer" >}}
{{< badge "FinOps" >}}
{{< duration "15 mins" >}}


AWS Cost Anomaly Detection uses machine learning to identify unusual spend patterns. AWS documents that it uses Cost Explorer data, monitors net unblended cost, and can rank root causes across service, account, Region, and usage type.

## Step 1 — Open Cost Anomaly Detection

Go to:

**Billing and Cost Management → Cost Anomaly Detection**

If Cost Explorer is not enabled, enable it first.

{{< note >}}
📸 **Screenshot placeholder — `10-01-cost-anomaly-home.png`**

Capture the Cost Anomaly Detection landing page.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Review existing monitors

Inspect current AWS-managed or custom monitors before creating duplicates.

{{< note >}}
📸 **Screenshot placeholder — `10-02-existing-monitors.png`**

Capture the current monitors list.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Create a monitor if needed

Choose **Create monitor**.

For the workshop:

```text
Name: FinOpsWorkshop-ServiceMonitor
```

Use a service-oriented scope or another monitor type appropriate to the account.

{{< note >}}
📸 **Screenshot placeholder — `10-03-create-monitor.png`**

Capture the monitor configuration before creation.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Create an alert subscription

Create/edit:

```text
FinOpsWorkshop-AnomalyAlerts
```

Select:

- the workshop monitor
- alert frequency
- a cost-impact threshold that avoids excessive noise

{{< note >}}
📸 **Screenshot placeholder — `10-04-alert-subscription.png`**

Capture the anomaly alert subscription configuration.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Allow learning/detection time

AWS notes that new monitors and new services need historical data before meaningful anomaly detection. Do not expect a detected anomaly immediately.

## Step 6 — Inspect a real anomaly when available

Review:

- impact
- service
- account
- Region
- usage type
- ranked root causes

{{< note >}}
📸 **Screenshot placeholder — `10-05-detected-anomaly.png`**

Capture a real detected anomaly if available. If none exists, do not fabricate one.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Comparison — deterministic workshop rule

A transparent custom rule can be:

```text
percentage increase > threshold
AND
absolute increase > threshold
```

This is useful for testing explicit materiality logic, while AWS Cost Anomaly Detection provides managed ML-based monitoring.

## Official reference

https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
