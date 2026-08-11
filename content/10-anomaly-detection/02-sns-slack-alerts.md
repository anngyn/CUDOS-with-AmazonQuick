---
title: "Alert Routing & Delivery Contract"
weight: 2
chapter: false
pre: "10.2 "
description: "Route approved anomaly signals through SNS to a governed collaboration channel and prove delivery safely."
services:
  - Amazon SNS
  - AWS Cost Anomaly Detection
  - Amazon Q Developer in chat applications
---
{{< badge "Amazon SNS" >}}
{{< badge "Alert Routing" >}}
{{< badge "Slack" >}}

## Routing architecture

```text
AWS Cost Anomaly Detection
        ↓
Amazon SNS topic
        ↓
Amazon Q Developer in chat applications
        ↓
Approved private Slack channel
        ↓
Named FinOps response owner
```

SNS decouples anomaly generation from the collaboration destination. A future consumer can subscribe without changing the anomaly monitor itself.

## Topic and ownership contract

The reference topic is `finops-project-cost-anomalies`. The anomaly subscription, topic policy, chat client, destination channel, and owner are documented together.

The Slack destination is private because notifications can contain financial scope, account, service, and usage information.

## Safe delivery validation

The project does not create artificial AWS spend to force an anomaly. A supported test notification is sufficient to prove the routing path:

```text
SNS topic:
Anomaly subscription:
Destination channel/team:
Test timestamp:
Delivery result: PASS / FAIL
Owner notified:
```

A real anomaly may later be retained as operational evidence, but it is not required to validate transport.

## Failure isolation

```text
Anomaly exists but no SNS publish
→ inspect subscription target and topic policy.

SNS publish succeeds but Slack receives nothing
→ inspect chat-client authorization and topic mapping.

Slack receives the alert but no owner responds
→ the technical route works; the operating model fails.
```

{{< capture src="images/10-custom-anomaly/10-02-sns-slack-delivery.png" alt="Timestamped SNS test notification delivered to the approved Slack channel" title="SNS-to-Slack delivery test" capture="Capture one supported test notification in the approved channel with a visible timestamp and delivery result. Retain enough topic or subscription context to identify the route, but redact account IDs, ARNs, emails, financial values, and private channel details." caption="A timestamped test proves transport without creating artificial AWS spend." >}}

## Current project status

The SNS topic `finops-project-cost-anomalies`, its policy for `costalerts.amazonaws.com`, and the Cost Anomaly subscription have been created in Sydney. No approved email, Slack, or chat endpoint is attached yet, so no delivery test has been performed or claimed.

{{< security >}}
Alert content is shared only with approved recipients, and test evidence excludes credentials and sensitive organization identifiers.
{{< /security >}}
