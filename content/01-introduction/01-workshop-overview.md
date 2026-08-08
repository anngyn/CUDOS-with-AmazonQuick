---
title: "Workshop Overview & Objectives"
weight: 1
chapter: false
pre: "1.1 "
description: "Overview of the AWS FinOps Intelligence Workshop architecture and objectives."
duration: "10 mins"
services:
  - AWS Billing
  - AWS Data Exports
  - Amazon Athena
  - Amazon Quick Sight
  - Amazon Quick
---
{{< badge "AWS Billing" >}}
{{< badge "FinOps" >}}
{{< badge "Amazon Quick" >}}
{{< duration "10 mins" >}}

# Workshop Overview & Objectives

Welcome to the **AWS FinOps Intelligence Workshop**. This hands-on workshop guides you through building a modern AWS-native FinOps environment from the billing-data foundation to dashboards, investigation, and optional agentic workflows.

## Scenario

Assume a fictional organization runs production, staging, and shared-service workloads on AWS. The FinOps team wants to answer:

- How much are we spending?
- Which services and accounts generate the largest spend?
- How is spend changing over time?
- Which workloads can be allocated to teams, products, or cost centers?
- Which cost spikes need investigation?
- Can repetitive investigations be accelerated safely?

## What you will build

```text
AWS Billing
     ↓
AWS Data Exports
     ↓
CUR 2.0
     ↓
Amazon S3
     ↓
AWS Glue Data Catalog
     ↓
Amazon Athena
     ↓
CUDOS v5
     ↓
Amazon Quick Sight
     ↓
Amazon Quick
```

The advanced path adds:

```text
CUDOS / FinOps dashboards
        ↓
Amazon Quick Space
        ↓
FinOps Chat Agent
        ↓
Quick Flow
```

## Learning objectives

By the end of the workshop you will be able to:

1. Explain CUR 2.0 and AWS Data Exports.
2. Validate CUR delivery to S3.
3. Inspect the Glue catalog and query CUR with Athena.
4. Deploy CUDOS v5.
5. Navigate CUDOS using real FinOps questions.
6. Customize Quick Sight analyses and calculated fields.
7. Ground Amazon Quick with CUDOS and custom FinOps context.
8. Ask natural-language FinOps questions and verify answers against source evidence.
9. Build a repeatable Quick Flow for cost investigation.
10. Configure AWS Cost Anomaly Detection and alerting.
11. Apply least privilege and governance controls.
12. Remove workshop resources cleanly.

## Core versus advanced path

The core path ends after CUDOS and Quick Sight customization. Amazon Quick chat agents and Flows are advanced modules and can be skipped if the account does not have the required capabilities.

## Workshop principles

### Evidence before AI

```text
Billing data → deterministic metric → validation → AI explanation
```

### Visibility before optimization

Understand **what changed, where, and who owns it** before recommending a change.

### Human review before remediation

This workshop does not give an AI agent unrestricted permission to terminate instances, delete databases, change IAM, or purchase commitments.

{{< validation >}}
Before moving on, make sure you can explain the difference between the core data/BI path and the advanced AI workflow path.
{{< /validation >}}

{{< finops title="FinOps Takeaway" >}}
FinOps is not simply cost cutting. It creates shared financial accountability between engineering, finance, product, and leadership.
{{< /finops >}}
