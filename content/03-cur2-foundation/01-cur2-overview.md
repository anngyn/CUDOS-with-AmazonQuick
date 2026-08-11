---
title: "CUR 2.0 as the Financial Evidence Layer"
weight: 1
chapter: false
pre: "3.1 "
description: "Explain why CUR 2.0 is the project source of truth and how its delivery characteristics affect the design."
duration: "10 mins"
services:
  - AWS Data Exports
  - CUR 2.0
  - Amazon S3
---
{{< badge "CUR 2.0" >}}
{{< badge "AWS Data Exports" >}}
{{< badge "Amazon S3" >}}


## What is CUR 2.0?

CUR 2.0 is a detailed AWS cost and usage dataset delivered through AWS Data Exports. It can include billing, line-item, product, pricing, reservation, Savings Plans, resource-tag, and Cost Category information.

The exact fields populated depend on the charge type and service.

## Collection architecture

```text
Single project AWS account
        │
        ├── Source: AWS Billing / Data Exports
        │
        └── Destination: Data Collection
                ├── S3 bucket
                ├── Glue database/tables
                └── Athena query layer
```


## Why CUR instead of dashboard-only data?

CUDOS and Quick Sight are consumers of cost data. CUR 2.0 remains the reusable evidence layer for SQL, BI, custom analytics, and future tools.

## Parquet

The Data Exports collection pattern stores analytical data as Parquet. Columnar storage is useful for Athena because queries can read selected fields more efficiently than row-oriented text formats.

## Data delivery

AWS documents that the first Data Exports delivery typically takes around 24 hours and can take up to 72 hours. Plan the project accordingly.

## FinOps implications

Enable and govern cost allocation tags and Cost Categories before expecting meaningful team/product allocation. CUR does not automatically contain normalized `team` or `project` fields unless your organization supplies that taxonomy.

{{< finops title="FinOps Takeaway" >}}
Good dashboards start with good cost data. Establish the collection layer before designing KPIs.
{{< /finops >}}

## Official reference

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/data-exports.html
