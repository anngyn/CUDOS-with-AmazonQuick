---
title: "Delivery Validation, Freshness & Data Contract"
weight: 4
chapter: false
pre: "3.4 "
description: "Prove that real CUR 2.0 Parquet data reached the intended S3 partition and define its freshness limits."
services:
  - AWS Data Exports
  - Amazon S3
  - CUR 2.0
---
{{< badge "AWS Data Exports" >}}
{{< badge "Amazon S3" >}}
{{< badge "CUR 2.0" >}}

## Validation question

The data-foundation gate asks one concrete question: did the configured export deliver a real CUR 2.0 object to the S3 location that the catalog and dashboards will consume?

A successful CloudFormation stack is insufficient. It can exist for hours before the first billing delivery.

## Delivery contract

The official collection pattern produces a path similar to:

```text
s3://<prefix>-<destination-account-id>-data-exports/
    <export-name>/<source-account-id>/<export-name>/data/
    <billing-period>/*.parquet
```

The contract requires:

- the export type is CUR 2.0;
- the destination matches the stack-owned bucket;
- a current billing-period partition exists;
- at least one `.parquet` object is present;
- the object timestamp is consistent with the recorded export refresh.

## Observed evidence

{{< evidence src="images/03-cur2/03-12-cur2-parquet-delivery.png" alt="S3 billing-period partition containing a CUR 2.0 Parquet object" caption="Observed result: the current billing partition contains a real CUR 2.0 Parquet object." >}}

The retained machine-readable record is more important than screenshots of S3 navigation:

```text
Export name:
Bucket/prefix:
Billing partition:
Object count:
Latest object timestamp:
Validation status: PASS / FAIL
```

## Freshness limitation

AWS documents that the first delivery typically takes about 24 hours and can take up to 72 hours. Therefore, “no object yet” during that window is a pending state rather than proof of deployment failure.

This latency also affects downstream interpretation: Athena may read newer objects than a CUDOS dataset whose SPICE ingestion has not refreshed yet.

## Historical data decision

Backfill of CUR/FOCUS history can be requested through AWS Support, subject to account and support-plan conditions. It is an optional data migration decision, not a prerequisite for proving the current-period pipeline.

{{< security >}}
Bucket names and prefixes can expose account identifiers. Public evidence is reviewed or redacted without changing the underlying validation record.
{{< /security >}}

{{< finops title="FinOps Takeaway" >}}
The first credible result of the project is not a dashboard; it is a verified, timestamped financial dataset in the expected partition.
{{< /finops >}}
