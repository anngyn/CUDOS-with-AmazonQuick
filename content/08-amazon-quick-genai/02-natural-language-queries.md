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

| Prompt | Authoritative CUDOS/Athena value | Agent value | Scope/metric stated | Result |
|---|---:|---:|---|---|
| Top service |  |  | yes/no | PASS/FAIL |
| Largest change |  |  | yes/no | PASS/FAIL |
| Account/Region attribution |  |  | yes/no | PASS/FAIL |

An answer fails if it is numerically wrong, omits the period or metric, invents a cause, or implies that remediation is approved. Fluent language does not compensate for failed grounding.

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

{{< capture src="images/08-amazon-quick/08-01-grounded-finops-answer.png" alt="Amazon Quick response grounded in reconciled CUDOS and Athena evidence" title="Grounded Amazon Quick answer" capture="Capture one representative question and answer showing the requested period, named cost metric, scoped value, attribution, and source-backed evidence. The answer must label hypotheses and must not imply remediation approval." caption="One evaluated answer is sufficient; the numerical evaluation table determines PASS or FAIL." >}}

{{< finops title="FinOps Takeaway" >}}
Natural language improves accessibility only when deterministic financial evidence remains authoritative.
{{< /finops >}}
