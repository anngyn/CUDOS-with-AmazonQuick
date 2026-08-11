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

{{< capture src="images/09-agentic-finops/09-01-cost-investigation-flow-result.png" alt="Final page of an Amazon Quick Flow report with REVIEW REQUIRED, SYNTHETIC classification, and no workload action authorized" title="Governed investigation Flow result" capture="Final page rendered from the Amazon Quick Flows PDF export. It shows the completed July 2026 synthetic run: period, ap-southeast-2 scope, AmazonEC2 $693.30 evidence, unverified hypothesis, human review, and no authorized workload action." caption="The Flow completed a read-only investigation run. This image is page 9 of its exported report, not a dashboard screenshot." >}}

[Download the complete Amazon Quick Flows export (10 pages)](/evidence/09-agentic-finops/09-01-cost-investigation-flow-result.pdf)

## Current project status

A real run of the draft Amazon Quick Flow `Cost Investigation – July 2026 [Synthetic]` was completed in Sydney and exported as the evidence above. It reads the selected `CUDOS Dashboard Demo [Synthetic]` as a read-only Amazon QuickSight source, reports the reconciled July values, separates hypotheses from observations, and ends at `REVIEW REQUIRED`.

The Flow has not been published and the connected source is synthetic rather than a real CUR export. It therefore demonstrates the governed **investigation workflow**, not a production remediation capability. No workload-changing, notification, or other action integration is attached.

## Official reference

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html
