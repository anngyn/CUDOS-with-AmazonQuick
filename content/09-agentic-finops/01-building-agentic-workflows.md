---
title: "Building Autonomous Agentic FinOps Workflows"
weight: 1
chapter: false
pre: "9.1 "
description: "Build a repeatable CUDOS-backed cost anomaly investigation flow."
duration: "20 mins"
services:
  - Amazon Quick
  - Quick Flows
  - CUDOS v5
---
{{< badge "Amazon Quick" >}}
{{< badge "Quick Flows" >}}
{{< badge "Cost Investigation" >}}
{{< duration "20 mins" >}}


The flow automates **investigation**, not production changes.

## Step 1 — Create a Flow

1. Select **Flows**.
2. Choose **Create Flow**.
3. Choose **Create a blank flow**.

Name:

```text
Cost Anomaly Investigation
```

Description:

```text
Analyzes CUDOS cost changes, summarizes evidence, and recommends human-reviewed investigation actions.
```

{{< note >}}
📸 **Screenshot placeholder — `09-01-create-flow.png`**

Capture the new blank Flow and name.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Add Alert Threshold input

Add a **Text input**:

```text
Alert Threshold
```

Default:

```text
20% increase
```

{{< note >}}
📸 **Screenshot placeholder — `09-02-threshold-input.png`**

Capture the Alert Threshold input step.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Add Analysis Time Period

Add:

```text
Analysis Time Period
```

Default:

```text
Last 30 days vs previous 30 days
```

## Step 4 — Add CUDOS dashboard analysis

Add **Dashboards and topics**.

Title:

```text
Extract CUDOS Cost Data
```

Source:

```text
CUDOS Dashboard v5
```

Prompt:

```text
Analyze cost trends for @Analysis Time Period.
Identify cost increases above @Alert Threshold.
Report the largest changes by service and include relevant account, Region, or resource context available in CUDOS.
Do not infer root cause yet.
```

{{< note >}}
📸 **Screenshot placeholder — `09-03-cudos-flow-step.png`**

Capture the CUDOS dashboard step and prompt.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Add reasoning

Create a Reasoning group:

```text
Cost Investigation
```

Instruction:

```text
If CUDOS evidence shows a material increase above the threshold,
investigate likely explanations and propose verification steps.
If no material increase exists, produce a short no-action report.
```

## Step 6 — Add Root Cause Analysis

Prompt:

```text
Use @Extract CUDOS Cost Data.
Separate observed cost drivers from possible operational causes.
Rank possible causes and state what evidence would confirm each one.
```

## Step 7 — Add Human Review Plan

Prompt:

```text
Create a concise FinOps action plan.
For each action include evidence, owner to contact, verification required, and risk.
Do not execute infrastructure changes.
```

{{< note >}}
📸 **Screenshot placeholder — `09-04-flow-reasoning.png`**

Capture the reasoning group and Human Review Plan.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 8 — Publish and run

1. **Share and publish**
2. **Run mode**
3. **Start**

{{< note >}}
📸 **Screenshot placeholder — `09-05-flow-result.png`**

Capture a real Flow execution result.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 9 — Verify against CUDOS

Compare the largest mover and reported numbers with CUDOS.

## Official reference

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html
