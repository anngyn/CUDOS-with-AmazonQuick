---
title: "Workshop Overview & Architecture"
weight: 10
chapter: false
description: "Overview of the AWS FinOps Intelligence Workshop architecture and objectives."
duration: "10 mins"
services:
  - AWS Billing
  - AWS Data Exports
  - Amazon Athena
  - Amazon QuickSight
---

# Workshop Overview & Architecture

{{< badge "AWS Billing" >}} {{< badge orange "FinOps" >}}
{{< duration "10 mins" >}}

Welcome to the **AWS FinOps Intelligence Workshop**. This hands-on lab guides you through building a modern, automated FinOps intelligence platform on AWS.

## Architecture

```text
AWS Billing
└── AWS Data Exports / CUR 2.0 (Parquet)
      └── Amazon S3
            └── AWS Glue Data Catalog
                  └── Amazon Athena (SQL Queries)
                        └── CUDOS v5 (Amazon QuickSight)
                              └── Amazon Q & Agentic AI Workflows
```

## Key Objectives

- **Automate Billing Data Collection**: Deploy CUR 2.0 via AWS Data Exports into Amazon S3 in Parquet format.
- **SQL Analytics with Athena**: Query granular hourly usage and cost allocation data using Amazon Athena.
- **Visualize with CUDOS v5**: Deploy Cloud Intelligence Dashboards in Amazon QuickSight.
- **Generative & Agentic FinOps**: Use Amazon Q and autonomous AI agents for natural language cost queries and automated anomaly responses.
