---
title: "CUR 2.0 Collection Architecture & Deployment"
weight: 3
chapter: false
pre: "3.3 "
description: "Document the official CID deployment pattern, parameter decisions, IAM boundary, and resulting collection resources."
services:
  - AWS CloudFormation
  - AWS Data Exports
  - Amazon S3
  - AWS Glue
  - Amazon Athena
---
{{< badge "AWS CloudFormation" >}}
{{< badge "AWS Data Exports" >}}
{{< badge "CUR 2.0" >}}

## Deployment pattern

The project adopts the current AWS Cloud Intelligence Dashboards Data Exports destination template instead of maintaining a local fork. The official guide remains the template authority:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/data-exports.html`

This decision reduces custom infrastructure code, but it creates a versioning responsibility: the template version and actual parameters shown by CloudFormation must be recorded with the deployment.

{{< evidence src="images/03-cur2/2.%20launchstack.png" alt="Official CID Data Exports guide with Launch Stack button" caption="The official CID guide is the deployment entry point; an old copied template URL is not treated as authoritative." >}}

## Parameter decisions

The stack is named `CID-DataExports-Destination`. Both source and destination use the current account:

```text
Destination Account ID = <ACCOUNT_ID>
Source Account IDs      = <ACCOUNT_ID>
Manage CUR 2.0          = yes
FOCUS                    = no
Cost Optimization Hub   = no
Carbon export            = no
```

CUR 2.0 is the only enabled export because it is the dataset required by the current CUDOS scope. FOCUS, Cost Optimization Hub, and Carbon are not rejected as products; they are excluded to keep the first data contract small and testable.

{{< evidence src="images/03-cur2/3.destinationfordataexport.png" alt="CloudFormation parameters for the Data Exports destination stack" caption="Reference parameter set for the single-account destination architecture." >}}

## IAM and change boundary

The template creates IAM roles or managed policies needed by delivery and catalog automation. Acknowledging the CloudFormation capability permits that creation; it does not prove least privilege. The created roles are reviewed later against the analytical boundary in Chapter 11.

{{< evidence src="images/03-cur2/4.createstack.png" alt="CloudFormation IAM capability acknowledgement and Create stack button" caption="IAM capability is an explicit deployment decision whose resulting roles remain subject to review." >}}

## Resulting resource model

The destination stack is expected to create or coordinate:

- an S3 destination bucket;
- a CUR 2.0 Data Export;
- a Glue database and table automation;
- Athena-compatible metadata and supporting resources;
- policies required for delivery and query access.

CloudFormation `CREATE_COMPLETE` proves only that the control-plane deployment succeeded. It does not prove that billing records have arrived. Data delivery is validated separately.

## Deployment record

```text
Template/version shown by CloudFormation:
Region: ap-southeast-2
Stack name: CID-DataExports-Destination
Source/destination topology: single account
CUR 2.0 enabled: yes
Final stack status:
First failed resource/status reason (if any):
```

If the stack fails, the first failed logical resource and its status reason are treated as the root diagnostic evidence. Re-running with broader administrator permissions would obscure that evidence.

{{< validation >}}
The infrastructure layer is accepted when the stack reaches `CREATE_COMPLETE`, its resource model matches the design, and its exact version and parameters are recorded. Billing delivery remains a separate acceptance gate.
{{< /validation >}}
