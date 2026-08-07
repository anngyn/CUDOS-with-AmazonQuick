---
title: "CUR 2.0 Overview & Architecture"
weight: 1
chapter: false
pre: "<b>3.1 </b>"
description: "Understand the AWS CUR 2.0 export pipeline architecture and data collection model."
duration: "10 mins"
---

{{< badge "AWS Billing" >}} {{< badge orange "AWS Data Exports" >}}
{{< duration "10 mins" >}}

Cost and Usage Report 2.0 (CUR 2.0) is the modern AWS data export framework for delivering detailed cost, usage, and pricing information directly to Amazon S3.

## Data Pipeline Architecture

```text
AWS Account
    │
    ├── Billing Data
    │
    ▼
AWS Data Exports
    │
    ▼
CUR 2.0 (Parquet Format)
    │
    ▼
CID Data Export Destination Stack
    │
    ├── Amazon S3 Bucket
    ├── AWS Glue Catalog
    └── Athena Metadata
```

## Key Benefits of CUR 2.0

- **Columnar Parquet Output**: Optimized for high-speed SQL analytics in Amazon Athena.
- **Monthly Partitioning**: Scans only relevant time slices, dramatically lowering query costs.
- **Split Cost Allocation Data (SCAD)**: Provides granular cost splitting for shared resources and ECS/EKS clusters.
