---
title: "Natural Language FinOps Queries"
weight: 2
chapter: false
pre: "8.2 "
description: "Ask evidence-backed cost questions and verify answers against CUDOS."
duration: "15 mins"
services:
  - Amazon Quick
  - Chat Agents
  - CUDOS v5
---
{{< badge "Amazon Quick" >}}
{{< badge "Natural Language" >}}
{{< badge "FinOps" >}}
{{< duration "15 mins" >}}


## Step 1 — Visibility

Ask:

```text
Which AWS services had the highest spend in the last 30 days?
Show the top five and state the cost metric you used.
```

{{< note >}}
📸 **Screenshot placeholder — `08-07-agent-top-services.png`**

Capture the question and answer.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

Verify against CUDOS.

## Step 2 — Change

Ask:

```text
Which services increased the most compared with the previous equivalent period?
Separate absolute change from percentage change.
```

{{< note >}}
📸 **Screenshot placeholder — `08-08-agent-cost-change.png`**

Capture the comparative response.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Attribution

Ask:

```text
For the largest increase, which account or Region contributed most?
Only state values supported by the connected dashboards.
```

{{< note >}}
📸 **Screenshot placeholder — `08-09-agent-attribution.png`**

Capture the attribution response.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Investigation

Ask:

```text
Based on the connected FinOps data, what should the FinOps team investigate first?
Separate observations from hypotheses and give verification steps.
```

{{< note >}}
📸 **Screenshot placeholder — `08-10-agent-investigation.png`**

Capture the recommended investigation.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Evaluate grounding

Check:

- correct period
- numbers consistent with CUDOS
- observations separated from hypotheses
- no fabricated remediation

{{< finops title="FinOps Takeaway" >}}
Natural language improves accessibility, but source dashboards and cost data remain authoritative.
{{< /finops >}}
