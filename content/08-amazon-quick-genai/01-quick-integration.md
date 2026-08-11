---
title: "Amazon Quick Grounding Architecture"
weight: 1
chapter: false
pre: "8.1 "
description: "Describe the optional AI experience layer, its approved knowledge sources, instructions, ownership, and trust boundary."
services:
  - Amazon Quick
  - Spaces
  - Chat Agents
---
{{< badge "Amazon Quick" >}}
{{< badge "Grounded AI" >}}
{{< badge "Optional Extension" >}}

Official reference:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html`

## Architectural role

Amazon Quick improves access to approved FinOps evidence through natural-language questions. It does not calculate the financial source of truth and is not required for the CUR → Athena → CUDOS core system.

```text
Approved CUDOS / Quick Sight dashboards
        ↓ linked into
FinOps Space
        ↓ grounds
FinOps Operations Advisor
        ↓ produces
Explanation and investigation plan
        ↓ validated against
CUDOS and Athena
```

## Knowledge boundary

The reference Space is named `AWS FinOps Intelligence` and contains only approved FinOps dashboards. The chat agent is named `FinOps Operations Advisor` and links to that Space as its knowledge source.

This boundary limits the agent to reviewed analytical assets instead of broad, ungoverned organizational data.

## Instruction policy

```text
Use linked FinOps dashboards and Space as the primary financial evidence.
State time period and scope when reporting spend.
Do not invent financial values.
Separate observed drivers from possible causes.
Recommend investigation steps before remediation.
Do not claim workload-changing action has been approved.
```

Instructions reduce predictable failure modes but do not guarantee numerical correctness. Runtime answers are still evaluated.

## Ownership record

```text
Agent:
Linked Space:
Linked dashboards:
Instruction version:
Owner:
Sharing scope:
Last evaluation:
Status: READY / BLOCKED / OPTIONAL
```

## Current project status

The grounding architecture, instruction policy, and evaluation contract are defined. Live availability and agent execution evidence have not been added, so this remains an optional extension rather than a completed core capability.

{{< security >}}
The agent needs read access to approved analytical sources, not destructive EC2, RDS, S3, or IAM permissions.
{{< /security >}}
