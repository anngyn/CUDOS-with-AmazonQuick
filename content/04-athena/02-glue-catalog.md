---
title: "AWS Glue Data Catalog Inspection"
weight: 2
chapter: false
pre: "<b>4.2 </b>"
description: "Inspect Glue databases and tables registered by the CID deployment stack."
duration: "10 mins"
---

{{< badge "AWS Glue" >}}
{{< duration "10 mins" >}}

Inspect the Glue Data Catalog database (`athenacurcfn_cid`) created by the destination stack.

## Step 1 — Check Table Schemas

Verify that the CUR 2.0 table contains standard line item schema columns (`line_item_unblended_cost`, `line_item_usage_amount`, `identity_line_item_id`).
