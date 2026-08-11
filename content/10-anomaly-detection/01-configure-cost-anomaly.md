---
title: "Anomaly Detection Strategy & Materiality"
weight: 1
chapter: false
pre: "10.1 "
description: "Combine AWS-managed anomaly detection with transparent materiality rules and an accountable response model."
services:
  - AWS Cost Anomaly Detection
  - AWS Cost Explorer
---
{{< badge "AWS Cost Anomaly Detection" >}}
{{< badge "Materiality" >}}
{{< badge "FinOps" >}}

## Detection strategy

AWS Cost Anomaly Detection provides the managed signal. It uses Cost Explorer data, monitors net unblended cost, and can rank likely contributors across service, account, Region, and usage type.

The project complements that model with a transparent rule:

```text
percentage increase > threshold
AND
absolute increase > threshold
```

The two approaches answer different needs. Managed ML detects unusual behavior relative to historical patterns; the deterministic rule makes organizational materiality explicit and testable.

## Monitor scope

The reference monitor is service-oriented and named `FinOpsProject-ServiceMonitor`. Existing monitors are reviewed before a new one is introduced because duplicate scopes create duplicate alerts and unclear ownership.

```text
Monitor name:
Scope/type:
Accounts/services included:
Managed cost-impact threshold:
Deterministic percentage threshold:
Deterministic absolute threshold:
Alert frequency:
Response owner:
Expected response time:
```

## Materiality effect

Percentage alone is misleading on tiny baselines. A move from `$0.01` to `$0.10` is a 900% increase but may not justify incident handling. Absolute cost alone can miss a rapidly growing small workload. Requiring both produces a more useful review queue.

## Learning and interpretation limits

New monitors and services require historical data before managed anomaly detection becomes meaningful. Absence of an immediate anomaly is therefore not validation failure.

Ranked root causes remain analytical leads. They identify cost contributors but do not prove the operational event that caused them.

{{< capture src="images/10-custom-anomaly/10-01-cost-anomaly-monitor.png" alt="AWS Cost Anomaly Detection monitor and subscription configuration" title="Live anomaly monitor and ownership" capture="Capture the monitor and subscription summary showing the monitor name, service scope, alert frequency, materiality threshold, destination, and response owner. A detected anomaly is optional because a new monitor may still be learning." caption="This artifact proves the governed monitor exists; it does not claim that absence of an anomaly means zero risk." >}}

## Current project status

The monitor strategy, naming, materiality model, and ownership record are defined. A live monitor, subscription, detected anomaly, and response-time result have not yet been evidenced.

## Official reference

https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
