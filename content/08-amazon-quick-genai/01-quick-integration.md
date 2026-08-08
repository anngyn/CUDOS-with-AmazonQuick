---
title: "Amazon Quick Generative AI Integration"
weight: 1
chapter: false
pre: "8.1 "
description: "Create a FinOps Space and a CUDOS-aware chat agent."
duration: "15 mins"
services:
  - Amazon Quick
  - Spaces
  - Chat Agents
---
{{< badge "Amazon Quick" >}}
{{< badge "Spaces" >}}
{{< badge "Chat Agents" >}}
{{< duration "15 mins" >}}


Official reference:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html`

## Step 1 — Create a Space

In Amazon Quick:

1. Select **Spaces**.
2. Choose **Create space**.
3. Name:

```text
AWS FinOps Intelligence
```

4. Description:

```text
FinOps workspace grounded in CUDOS and workshop cost dashboards.
```

{{< note >}}
📸 **Screenshot placeholder — `08-01-create-finops-space.png`**

Capture the Space creation form.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Add CUDOS

Open the Space:

1. Select **Dashboards**.
2. Choose **Add dashboards**.
3. Add CUDOS v5.
4. Add `FinOps Workshop Dashboard`.

{{< note >}}
📸 **Screenshot placeholder — `08-02-space-dashboards.png`**

Capture the Space showing CUDOS and the custom FinOps dashboard.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Create a chat agent

1. Select **Chat agents**.
2. Choose **Create Chat Agent**.
3. Follow the current agent creation flow.
4. Name:

```text
FinOps Operations Advisor
```

5. Description:

```text
AWS FinOps advisor grounded in CUDOS and approved workshop dashboards.
```

{{< note >}}
📸 **Screenshot placeholder — `08-03-create-chat-agent.png`**

Capture the chat-agent basic settings.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Configure instructions

Use:

```text
Use linked FinOps dashboards and Space as the primary financial evidence.
State time period and scope when reporting spend.
Do not invent financial values.
Separate observed drivers from possible causes.
Recommend investigation steps before remediation.
Do not claim workload-changing action has been approved.
```

{{< note >}}
📸 **Screenshot placeholder — `08-04-agent-instructions.png`**

Capture the agent instructions.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Link the Space

In **Knowledge sources**:

1. Choose **Link spaces**.
2. Select `AWS FinOps Intelligence`.
3. Add/link it.

{{< note >}}
📸 **Screenshot placeholder — `08-05-agent-knowledge-source.png`**

Capture the FinOps Space linked as a knowledge source.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Launch the agent

{{< note >}}
📸 **Screenshot placeholder — `08-06-agent-launched.png`**

Capture the launched FinOps Operations Advisor.

Replace this block with the real screenshot after completing the step.
{{< /note >}}
