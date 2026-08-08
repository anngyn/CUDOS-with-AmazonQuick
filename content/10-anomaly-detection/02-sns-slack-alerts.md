---
title: "Setting Up SNS & Slack Alerts"
weight: 2
chapter: false
pre: "10.2 "
description: "Route cost anomaly notifications through SNS and an approved Slack channel."
duration: "15 mins"
services:
  - Amazon SNS
  - AWS Cost Anomaly Detection
  - Amazon Q Developer in chat applications
---
{{< badge "Amazon SNS" >}}
{{< badge "Alerts" >}}
{{< badge "Slack" >}}
{{< duration "15 mins" >}}


AWS Cost Anomaly Detection subscriptions can notify an Amazon SNS topic. AWS documentation supports mapping SNS notifications into Slack or Amazon Chime through **Amazon Q Developer in chat applications**.

## Step 1 — Create an SNS topic

Open:

**Amazon SNS → Topics → Create topic**

Use:

```text
Type: Standard
Name: finops-workshop-cost-anomalies
```

{{< note >}}
📸 **Screenshot placeholder — `10-06-sns-topic.png`**

Capture the created SNS topic and ARN.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Connect SNS to Cost Anomaly Detection

Return to the workshop anomaly subscription and add the SNS topic as a notification target according to the current console options.

{{< note >}}
📸 **Screenshot placeholder — `10-07-anomaly-sns-subscription.png`**

Capture the anomaly subscription showing the SNS topic.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Configure Slack integration

If you have an approved Slack workspace:

1. Open **Amazon Q Developer in chat applications**.
2. Create/configure a Slack chat client.
3. Complete the AWS/Slack authorization workflow.
4. Select the approved private channel.

{{< note >}}
📸 **Screenshot placeholder — `10-08-chat-app-slack-config.png`**

Capture the AWS chat-application Slack configuration. Redact workspace/user details.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Map the SNS topic

Map:

```text
finops-workshop-cost-anomalies
```

to the approved channel.

{{< note >}}
📸 **Screenshot placeholder — `10-09-sns-slack-mapping.png`**

Capture the SNS topic mapped to the Slack channel.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Test safely

Do not create artificial cloud spend just to force an anomaly.

Verify:

- SNS topic exists
- anomaly subscription references it
- chat application configuration is healthy
- supported test notification reaches the channel

{{< note >}}
📸 **Screenshot placeholder — `10-10-slack-test-message.png`**

Capture a test or real anomaly notification. Do not fabricate anomaly content.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< security >}}
Cost alerts can contain service, account, and financial information. Use an approved private channel.
{{< /security >}}
