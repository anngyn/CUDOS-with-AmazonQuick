---
title: "Governed Cost Investigation Flow"
weight: 1
chapter: false
pre: "9.1 "
description: "Model a repeatable CUDOS-backed investigation that automates evidence preparation without executing workload changes."
services:
  - Amazon Quick
  - Quick Flows
  - CUDOS v5
---
{{< badge "Amazon Quick" >}}
{{< badge "Quick Flows" >}}
{{< badge "Governed Investigation" >}}

## Workflow purpose

Repeated cost investigations usually follow the same analytical sequence. The `Cost Anomaly Investigation` Flow standardizes that sequence while keeping remediation outside the agent’s authority.

```text
Period + materiality threshold
→ extract CUDOS evidence
→ identify material movers
→ separate driver from hypothesis
→ propose verification
→ produce human-review package
```

## Inputs and materiality

The Flow receives explicit inputs rather than assuming them:

```text
Alert Threshold: 20% increase
Analysis Time Period: Last 30 days vs previous 30 days
```

Production use should pair percentage materiality with an absolute-cost threshold so low-value percentage spikes do not dominate the queue.

## Evidence extraction

The dashboard stage uses CUDOS as its approved source:

```text
Analyze cost trends for @Analysis Time Period.
Identify cost increases above @Alert Threshold.
Report the largest changes by service and include available account,
Region, usage-type, or resource context.
Do not infer root cause yet.
```

The `do not infer root cause yet` boundary prevents the evidence-extraction stage from presenting hypotheses as observed facts.

## Reasoning and review package

The reasoning stage ranks possible causes and states what evidence would confirm each one. Its final output contains:

```text
Observed evidence
Financial impact
Affected scope
Possible causes
Verification required
Owner
Proposed action
Risk and rollback
Status: REVIEW REQUIRED
```

No workload-changing tool is attached to the Flow.

## Run evaluation

```text
Flow version/run time:
Input period and threshold:
Largest mover reported by Flow:
Authoritative CUDOS/Athena value:
Observed drivers:
Hypotheses clearly separated: yes/no
Human-review status present: yes/no
Workload-changing action executed: no
Result: PASS / FAIL
```

One final Flow result and its evaluation record are sufficient evidence. Node-by-node configuration screenshots are not required.

{{< capture src="images/09-agentic-finops/09-01-cost-investigation-flow-result.png" alt="Evaluated Cost Anomaly Investigation Flow result requiring human review" title="Governed investigation Flow result" capture="Capture the final evaluated Flow run with its input period and thresholds, largest reconciled mover, observed evidence, separated hypotheses, verification required, owner, risk and rollback, and the status REVIEW REQUIRED. Show that no workload-changing action executed." caption="The final run and evaluation are evidence; node configuration screens are not." >}}

## Current project status

The Flow design and evaluation contract are defined. A published Flow and real evaluated run have not yet been supplied, so the capability remains pending and optional.

## Official reference

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html
