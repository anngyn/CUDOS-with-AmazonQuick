---
title: "Configuring AWS Cost Anomaly Detection"
weight: 1
chapter: false
pre: "<b>10.1 </b>"
description: "Configure machine learning monitors and alert subscriptions for cost anomalies."
duration: "20 mins"
services:
  - AWS Cost Anomaly Detection
  - Amazon SNS
---

{{< badge "AWS Cost Anomaly Detection" >}}
{{< duration "20 mins" >}}

AWS Cost Anomaly Detection uses machine learning to continuously monitor your cost and usage to detect anomalous spend.

## Step 1 — Create an Anomaly Monitor

1. Open **AWS Billing & Cost Management → Cost Anomaly Detection**.
2. Create a monitor for **AWS Services**.

## Step 2 — Configure Alert Subscription

Create an alert subscription to send notifications via Amazon SNS or Slack/Teams webhooks when an anomaly exceeds $50.
