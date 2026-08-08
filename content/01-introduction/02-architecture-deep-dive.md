---
title: "FinOps Architecture Deep-Dive"
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
{{< duration "10 mins" >}}

# FinOps Architecture Deep-Dive

## Overall architecture

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
                    Amazon Quick Sight
                             │
                             ▼
                        Amazon Quick
                     ┌───────┴────────┐
                     ▼                ▼
                 Chat Agent       Quick Flows
```

{{< note >}}
📸 **Screenshot placeholder — `01-01-workshop-architecture.png`**

Create a clean architecture diagram showing the data path from AWS Billing to Amazon Quick. Do not use an AWS Console screenshot for this image.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Layer 1 — AWS Billing and Data Exports

AWS Billing produces cost and usage records. AWS Data Exports exposes billing datasets such as CUR 2.0 and delivers them to S3.

CUR 2.0 is the financial evidence layer used throughout the workshop.

## Layer 2 — Amazon S3

S3 stores the delivered Parquet data. The Data Collection architecture separates durable cost data from the dashboards that consume it.

## Layer 3 — AWS Glue

Glue provides catalog metadata so Athena can interpret the objects as tables and columns.

## Layer 4 — Amazon Athena

Athena provides serverless SQL over CUR data. It is where you validate data, inspect cost dimensions, and create reproducible financial queries.

## Layer 5 — CUDOS v5

CUDOS is an AWS Cloud Intelligence Dashboard. It uses CUR/Athena data and Quick Sight datasets to provide executive, service, resource, commitment, and optimization-oriented FinOps views.

## Layer 6 — Amazon Quick Sight

Quick Sight is the BI capability inside Amazon Quick. It provides datasets, SPICE, analyses, visuals, filters, controls, and published dashboards.

## Layer 7 — Amazon Quick

Quick adds natural-language analysis, Spaces, chat agents, and Flows. It should consume approved data rather than become the calculator of record.

## Separation of responsibilities

| Layer | Responsibility |
|---|---|
| CUR 2.0 | Financial evidence |
| S3 | Durable storage |
| Glue | Metadata/catalog |
| Athena | Query and semantic calculations |
| CUDOS | AWS FinOps intelligence |
| Quick Sight | BI and visualization |
| Amazon Quick | Conversational analysis and workflows |

{{< security >}}
The analytics stack is read-oriented. Cost visibility does not require permission to modify the workloads generating the cost.
{{< /security >}}

## Official references

- https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/cudos-cid-kpi.html
- https://docs.aws.amazon.com/quick/latest/userguide/what-is.html
