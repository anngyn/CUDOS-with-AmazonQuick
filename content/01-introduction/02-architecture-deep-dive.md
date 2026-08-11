---
title: "Architecture & Design Decisions"
weight: 2
chapter: false
pre: "1.2 "
description: "Understand each data, analytics, BI, AI, and governance layer."
duration: "10 mins"
services:
  - AWS Data Exports
  - Amazon S3
  - AWS Glue
  - Amazon Athena
  - Amazon Quick Sight
  - Amazon Quick
---
{{< badge "Architecture" >}}
{{< badge "FinOps" >}}


## System context

{{< evidence src="images/architecture/aws-finops-cudos-architecture.png" alt="AWS FinOps Intelligence architecture with CUR 2.0, S3, Glue, Athena, CUDOS v5, Amazon QuickSight, Amazon Q, anomaly notification, and governance" caption="Project architecture: financial evidence flows into reproducible analytics, CUDOS intelligence, optional AI assistance, and human-governed operations." >}}

```text
                         AWS Billing
                             │
                             ▼
                      AWS Data Exports
                          CUR 2.0
                             │
                             ▼
                         Amazon S3
                             │
                             ▼
                     AWS Glue Catalog
                             │
                             ▼
                        Amazon Athena
                             │
                             ▼
                         CUDOS v5
                             │
                             ▼
                    Amazon QuickSight
                             │
                             ▼
                        Amazon Q
                     ┌───────┴────────┐
                     ▼                ▼
                 Chat Agent       Q Flows
```


## Why the architecture is layered

The layers deliberately separate evidence, calculation, presentation, and explanation. This prevents a dashboard formula or AI response from silently redefining the financial source of truth.

The cause-and-effect relationship is clear:

```text
If CUR delivery is wrong
→ Athena and CUDOS will both be wrong.

If Athena and CUDOS disagree
→ inspect the metric definition, scope, and refresh state before trying to find a business cause.

If AI disagrees with reconciled CUDOS/Athena evidence
→ the AI answer fails validation; the financial record remains unchanged.
```

## Financial evidence: AWS Billing and Data Exports

AWS Billing produces cost and usage records. AWS Data Exports packages these billing datasets into CUR 2.0 and delivers them to S3.

CUR 2.0 acts as the financial source of truth throughout the project.

## Durable storage: Amazon S3

S3 stores the delivered Parquet data. This architecture separates the durable cost data from the dashboards that consume it.

## Data contract: AWS Glue

Glue provides the catalog metadata that Athena needs to interpret S3 objects as tables and columns.

## Reproducible calculation: Amazon Athena

Athena enables serverless SQL querying over CUR data. This is where you validate data, inspect cost dimensions, and create reproducible financial queries.

## FinOps analytical product: CUDOS v5

CUDOS is an AWS Cloud Intelligence Dashboard. It uses CUR/Athena data and QuickSight datasets to provide executive, service, resource, commitment, and optimization-oriented FinOps views.

## Presentation layer: Amazon QuickSight

QuickSight provides the core BI capability. It manages datasets, SPICE, analyses, visuals, filters, controls, and published dashboards.

## Assisted investigation: Amazon Q

Amazon Q introduces natural-language analysis, Spaces, chat agents, and Flows. It should only query approved data rather than performing official financial calculations.

## Responsibility boundaries

| Layer | Responsibility |
|---|---|
| CUR 2.0 | Financial evidence |
| S3 | Durable storage |
| Glue | Metadata/catalog |
| Athena | Query and semantic calculations |
| CUDOS | AWS FinOps intelligence |
| Amazon QuickSight | BI and visualization |
| Amazon Q | Conversational analysis and workflows |

## Key design decisions

| Decision | Reason | Operational effect |
|---|---|---|
| CUR 2.0 in Parquet | Detailed reusable billing evidence with efficient column scans | Athena validation remains independent of the dashboard |
| Starting with a single account | Reduces source/destination and IAM complexity while proving the pattern | Multi-account aggregation is a later architecture extension |
| Athena as a reconciliation layer | SQL is transparent, inspectable, and repeatable | Dashboard values can be challenged with evidence |
| Prioritizing CUDOS over custom BI | Reuses AWS-maintained FinOps semantics | Custom visuals focus on decisions rather than rebuilding the entire model |
| Read-only analytical access | Cost visibility does not require modifying running workloads | A compromised BI or AI identity has a smaller blast radius |
| Human approval for remediation | System recommendations often lack full workload context | Resource changes remain owned by engineering and business teams |

{{< security >}}
The analytics stack is strictly read-only. Cost monitoring does not require permission to modify the workloads generating the cost.
{{< /security >}}

## Official references

- https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/cudos-cid-kpi.html
- https://docs.aws.amazon.com/quick/latest/userguide/what-is.html
