---
title: "Glue Catalog, Schema Contract & S3 Lineage"
weight: 2
chapter: false
pre: "4.2 "
description: "Show how Glue connects CUR Parquet objects to reproducible Athena and CUDOS queries."
services:
  - AWS Glue
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS Glue" >}}
{{< badge "Data Catalog" >}}
{{< badge "Amazon S3" >}}

## Catalog role

Glue is the data contract between storage and calculation. It tells Athena which S3 prefix contains the dataset and how each Parquet field should be interpreted.

If the catalog points to the wrong prefix, SQL can still be syntactically valid while reporting incomplete or unrelated financial data. Catalog inspection is therefore a lineage check rather than a console tour.

## Observed catalog

The database name is taken from the deployed environment. Current evidence shows `cid_data_export`; the same representative Athena evidence in 4.1 is sufficient because Athena resolves the Glue database and table before it can execute the query.

The project records:

```text
Glue database:
Glue table:
S3 table location:
Input/output format:
Partition model:
Current billing partition:
```

## Schema contract

The table must expose the groups required by the financial model:

- bill and billing period;
- line item and usage account;
- product/service and pricing;
- reservation and Savings Plans;
- resource tags and Cost Categories;
- cost fields used by the selected metrics.

A column being present does not mean it is populated for every charge. Metric SQL must handle service- and line-item-specific sparsity.

## S3 lineage

The table `Location` is compared with the Data Exports prefix validated in Chapter 3:

```text
Data Export destination
        ↓ must match
Glue table Location
        ↓ interpreted by
Athena table
        ↓ consumed by
CUDOS datasets
```

```text
Glue database:
Glue table:
S3 table location:
Validated delivery prefix:
Location match: yes/no
Lineage status: PASS / INVESTIGATE
```

{{< finops title="FinOps Takeaway" >}}
Financial lineage is part of metric credibility. A chart cannot be trusted if its table-to-S3 mapping is unknown.
{{< /finops >}}
