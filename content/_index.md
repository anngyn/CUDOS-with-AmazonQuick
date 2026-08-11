---
title: "AWS FinOps Intelligence with CUDOS v5"
chapter: false
description: "An evidence-backed AWS FinOps implementation built on CUR 2.0, Athena, CUDOS v5, QuickSight, and governed automation."
---

{{< finops-hero
  label="AWS FinOps implementation · Sydney"
  headline="Turn billing records into governed FinOps decisions."
  summary="A production-style CUDOS project that keeps the financial source, analytical evidence, recommendation, and human approval visibly separate."
  proof_one_label="Financial source"
  proof_one_value="CUR 2.0 → Athena"
  proof_two_label="Analysis product"
  proof_two_value="CUDOS v5 + Amazon Quick"
  proof_three_label="Decision guardrail"
  proof_three_value="Evidence first. Human approval."
>}}

This repository documents the business problem, architecture, implementation decisions, validation evidence, operating model, and remaining gaps as one traceable AWS FinOps project.

{{< badge "FinOps" >}}
{{< badge "CUDOS v5" >}}
{{< badge "CUR 2.0" >}}

## Business problem

AWS billing data is detailed but fragmented. Finance needs trusted totals, engineering needs resource-level drivers, and service owners need actionable findings. Without a governed analytical path, teams either depend on manual Cost Explorer reviews or circulate numbers whose period, metric, filters, and refresh state are unclear.

The project addresses that problem by creating one traceable path from billing records to decisions.

## Implemented architecture

```text
AWS Billing
   ↓
AWS Data Exports / CUR 2.0       Financial evidence
   ↓
Amazon S3 + AWS Glue             Storage and catalog
   ↓
Amazon Athena                    Reproducible validation
   ↓
CUDOS v5 + QuickSight            FinOps analysis product
   ↓
Amazon Q / Flows                 Optional assisted investigation
   ↓
Human review + operating cadence Governed action
```

Cost Anomaly Detection and SNS provide the operational signal around this analytical path.

## Project outcomes

- a CUR 2.0 collection layer with real Parquet delivery;
- a catalogued Athena table and reproducible validation queries;
- a CUDOS deployment model with SPICE readiness checks;
- a reconciliation contract between Athena and CUDOS;
- structured FinOps findings with owner, evidence, action, and measured outcome;
- allocation and unit-economics definitions;
- anomaly notification, access governance, and lifecycle controls;
- an optional AI layer that explains approved evidence but does not replace it.

## Current delivery status

| Capability | Status | Evidence |
|---|---|---|
| CUR 2.0 delivery | Validated | Real Parquet delivery in the current billing partition |
| Athena and Glue | Validated | Database, table, schema, query result, and scan statistics |
| CUDOS v5 and Amazon Quick | Deployed | CUDOS v5, datasets, dashboard evidence, and a clearly labelled synthetic walkthrough are retained |
| FinOps findings | Synthetic measurement validated | Optimization, allocation, and unit-economics demonstrations are reconciled; a real-account outcome remains pending |
| Amazon Q and Flows | Live synthetic extension | A grounded Topic and governed Flow report run on the shared synthetic demonstration source; production grounding remains optional |
| Alerting and governance | Partially deployed | Service monitor, SNS routing foundation, security audit, and retained-resource inventory exist; delivery endpoint/test remains pending |

We intentionally track this status clearly: a documented design does not count as a working system.

## Project chapters

1. Business Context & Architecture
2. Environment & Access Boundary
3. CUR 2.0 Data Foundation
4. Athena Validation & Data Lineage
5. CUDOS v5 Analytical Product
6. FinOps Findings & Unit Economics
7. QuickSight Presentation Layer
8. Amazon Q AI Extension
9. Governed Investigation Workflow
10. Anomaly Detection & Notification
11. Security & Operating Model
12. Resource Lifecycle

{{< cost >}}
The implementation can create billable S3, Athena, SPICE, Amazon Q, and supporting resources. Every created resource must have an owner and a retain-or-delete decision.
{{< /cost >}}
