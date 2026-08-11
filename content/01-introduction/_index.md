---
title: "Business Context & Architecture"
weight: 1
chapter: false
pre: "1. "
description: "Business problem, success criteria, architecture, and design boundaries."
duration: "10 mins"
services:
  - AWS Billing
  - FinOps
  - Amazon Quick
---
{{< badge "AWS Billing" >}}
{{< badge "FinOps" >}}
{{< badge "Amazon Quick" >}}


This chapter explains why the system exists, what success means, and why evidence, analytics, presentation, and automation are separated.

AWS billing data contains detailed financial evidence, but raw records do not automatically answer business questions such as:

- Which services drive our spend?
- Which accounts or Regions changed the most?
- Who owns the cost?
- Which change is expected and which is anomalous?
- Where should the FinOps team investigate first?

The project builds a traceable path from raw billing evidence to dashboards and AI-assisted investigation.

## Chapter contents

- **1.1 Business Context, Goals & Success Criteria**
- **1.2 Architecture & Design Decisions**

{{< finops title="FinOps Principle" >}}
Use deterministic financial data as the source of truth. Add dashboards and AI on top of evidence rather than asking AI to invent the evidence.
{{< /finops >}}
