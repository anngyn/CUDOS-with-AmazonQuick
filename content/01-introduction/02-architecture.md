---
title: "FinOps Architecture Deep-Dive"
weight: 2
chapter: false
pre: "<b>1.2 </b>"
description: "Understand the end-to-end data pipeline from billing to agentic AI."
duration: "10 mins"
---

{{< badge "Architecture" >}} {{< badge orange "FinOps" >}}
{{< duration "10 mins" >}}

This section breaks down how data flows through each service in the workshop:

1. **AWS Data Exports**: Extracts raw CUR 2.0 billing records.
2. **Amazon S3**: Stores Parquet files partitioned by year and month.
3. **AWS Glue & Athena**: Catalogs schema and executes SQL queries.
4. **Amazon QuickSight & CUDOS**: Renders interactive dashboards.
5. **Amazon Q & Agentic AI**: Provides natural language Q&A and automated anomaly remediation.
