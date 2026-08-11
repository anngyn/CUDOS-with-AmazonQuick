---
title: "AI Grounding & Numerical Evaluation"
weight: 2
chapter: false
pre: "8.2 "
description: "Evaluate whether natural-language answers preserve period, metric, attribution, and evidence."
services:
  - Amazon Quick
  - Chat Agents
  - CUDOS v5
---
{{< badge "Amazon Quick" >}}
{{< badge "Evaluation" >}}
{{< badge "FinOps" >}}

## Evaluation objective

The test is not whether the answer sounds useful. The test is whether the agent reports the same scoped values as the connected CUDOS/Athena evidence and labels hypotheses correctly.

## Query classes

| Class | Example question | Required evidence behavior |
|---|---|---|
| Visibility | Which five services had the highest spend? | State period and cost metric |
| Change | Which services increased most? | Separate absolute and percentage change |
| Attribution | Which account or Region drove the largest increase? | Use connected dashboard dimensions only |
| Investigation | What should be investigated first? | Separate observations, hypotheses, and verification |

## Evaluation record

| Prompt | Authoritative value | Amazon Quick value | Scope/metric stated | Result |
|---|---:|---:|---|---|
| Top service | AmazonEC2 — $693.30 net unblended cost | AmazonEC2 — $693.30 net unblended cost | July 2026; `ap-southeast-2`; net unblended cost | PASS |
| Largest change | Not evaluated | Not evaluated | — | NOT EVALUATED |
| Account/Region attribution | Not evaluated | Not evaluated | — | NOT EVALUATED |

The PASS row is evaluated against the shared **synthetic** Athena-backed dashboard, not real CUR billing data. An answer fails if it is numerically wrong, omits the period or metric, invents a cause, or implies that remediation is approved. Fluent language does not compensate for failed grounding.

## Failure handling

```text
Wrong number
→ verify linked dashboard, filters, and refresh state.

Correct number, wrong explanation
→ constrain instructions and require source-backed attribution.

Unsupported remediation
→ block the output from the action workflow and require human review.
```

One representative question/answer can be retained as project evidence. The evaluation table is authoritative; screenshots of every prompt are unnecessary.

{{< capture src="images/08-amazon-quick/08-01-grounded-finops-answer.png" alt="Amazon Quick response correctly grounded in the selected synthetic CUDOS dashboard" title="Grounded Amazon Quick answer" capture="The selected dashboard, question, answer, July 2026 period, ap-southeast-2 scope, AmazonEC2 value, and source sheet are visible. This is a successful test against the shared synthetic Athena source." caption="The single evaluated answer passes: AmazonEC2 is $693.30 net unblended cost in July 2026 for ap-southeast-2. The proof is synthetic, not a real CUR billing result." >}}

{{< finops title="FinOps Takeaway" >}}
Natural language improves accessibility only when deterministic financial evidence remains authoritative.
{{< /finops >}}
