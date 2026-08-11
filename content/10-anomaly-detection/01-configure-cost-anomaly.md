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

## Deployed configuration

The following governed monitor now exists in `ap-southeast-2` (Sydney):

```text
Monitor name: FinOpsProject-ServiceMonitor
Monitor type: DIMENSIONAL / SERVICE
Managed cost-impact threshold: USD 10
Alert frequency: IMMEDIATE
Cost Anomaly subscription: finops-project-cost-anomaly-subscription
SNS topic: finops-project-cost-anomalies
Deterministic review rule: percentage increase > 20% AND absolute increase > USD 10
```

The managed service applies the USD threshold. The 20% rule remains a transparent FinOps triage rule applied by the human reviewer; it is not an extra Cost Anomaly Detection filter.

## Materiality effect

Percentage alone is misleading on tiny baselines. A move from `$0.01` to `$0.10` is a 900% increase but may not justify incident handling. Absolute cost alone can miss a rapidly growing small workload. Requiring both produces a more useful review queue.

## Learning and interpretation limits

New monitors and services require historical data before managed anomaly detection becomes meaningful. Absence of an immediate anomaly is therefore not validation failure.

Ranked root causes remain analytical leads. They identify cost contributors but do not prove the operational event that caused them.

{{< capture src="images/10-custom-anomaly/10-01-cost-anomaly-monitor.svg" alt="Sanitized live AWS CLI evidence of the Cost Anomaly Detection monitor and subscription configuration" title="Live anomaly monitor and routing" capture="Sanitized evidence generated from the live AWS CLI configuration. It shows the monitor name, SERVICE scope, immediate USD 10 threshold, SNS routing topic, and detector learning state without exposing identifiers." caption="This artifact proves the governed monitor and routing foundation exist. It does not claim an anomaly, a delivery endpoint, or zero risk." >}}

## Current project status

The live monitor and its SNS-based Cost Anomaly subscription have been created in Sydney. Its first evaluation date is still empty, which is expected while the managed detector learns the account's cost pattern. No anomaly has been detected or claimed.

The SNS topic currently has no email, Slack, or chat endpoint. The routing resource exists, but 10.2 remains pending until an approved destination and a timestamped test are supplied.

## Official reference

https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
