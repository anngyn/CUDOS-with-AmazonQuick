---
title: "Deploy the CUR 2.0 Data Export Foundation"
weight: 30
chapter: false

description: >
  Deploy the AWS Cloud Intelligence Dashboards Data Exports destination stack for a single-account CUR 2.0 workshop.

duration: "15–20 mins"
difficulty: "Intermediate"

services:
  - AWS Billing and Cost Management
  - AWS Data Exports
  - AWS CloudFormation
  - Amazon S3
  - AWS Glue
  - Amazon Athena

draft: false
---

# Deploy the CUR 2.0 Data Export Foundation

{{< badge "AWS Billing and Cost Management" >}} {{< badge orange "AWS Data Exports" >}} {{< badge "AWS CloudFormation" >}}
{{< duration "15–20 mins" >}}

In this step, you will deploy the **CID Data Export Destination Stack** using AWS CloudFormation. This establishes the automated data foundation required for subsequent analytics, visualization, and AI workflow modules.

---

## Workshop Context & Architecture

This lab provisions the FinOps billing data pipeline that will later feed:

- **Amazon Athena** (SQL query interface)
- **CUDOS v5** (Cloud Intelligence Dashboards)
- **Amazon QuickSight** (Business Intelligence)
- **Amazon Q** (Generative AI assistant)

### Step Architecture

```text
AWS Account
    │
    ├── Billing Data
    │
    ▼
AWS Data Exports
    │
    ▼
CUR 2.0
    │
    ▼
CID Data Export Destination Stack
    │
    ├── Amazon S3
    ├── AWS Glue
    └── Athena metadata
```

This workshop uses a **single-account architecture** where:

```text
Source Account = Destination / Data Collection Account
```

Because this is a workshop and demonstration environment, we deploy both source billing data exports and destination storage in a single AWS account to simplify setup while maintaining architectural fidelity.

---

## Region Selection

The primary AWS Region for this workshop is:

**Asia Pacific (Sydney) — `ap-southeast-2`**

This Region was selected because the workshop later utilizes broader Amazon Q capabilities in addition to Amazon QuickSight BI.

{{< note >}}
Verify that the AWS Console is using Asia Pacific (Sydney), `ap-southeast-2`, before creating the stack.
{{< /note >}}

---

## Prerequisites

Before proceeding with this deployment, verify that you have completed Module 02 and possess:

- AWS CLI access installed and configured on your workstation.
- A working AWS IAM identity (user or role) with permissions for CloudFormation, S3, Glue, Athena, and Billing/Data Exports.
- Access to the `ap-southeast-2` Region.
- Amazon QuickSight / Amazon Q onboarding completed.

---

## Step 1 — Verify AWS Identity

Run the following PowerShell command to confirm your active AWS identity:

```powershell
aws sts get-caller-identity `
  --profile DatTran
```

Retrieve and confirm your 12-digit AWS Account ID:

```powershell
aws sts get-caller-identity `
  --profile DatTran `
  --query Account `
  --output text
```

This Account ID will be reused as both the **Destination Account ID** and the **Source Account ID** in the CloudFormation parameter configuration.

{{< security >}}
Do not publish unredacted account identifiers, IAM ARNs, email addresses, or other sensitive account information in public workshop screenshots.
{{< /security >}}

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Verify AWS identity](/images/03-cur2/03-01-caller-identity.png)

---

## Step 2 — Open the Official AWS Deployment Guide

Do not manually write or copy a CloudFormation template. Instead, open the official **AWS Cloud Intelligence Dashboards Data Exports deployment guide**.

Follow the guided navigation path:

```text
Deployment
→ Step 1 of 3
→ Create Destination for Data Exports
→ Launch Stack
```

Click the official **Launch Stack** button. This opens the AWS CloudFormation creation wizard with the latest AWS Solutions Library template automatically populated.

*(Note: The official AWS Solutions Library template may be used as a fallback if needed, but the primary path is the Launch Stack button from the deployment guide).*

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![AWS Data Exports deployment guide](/images/03-cur2/03-02-launch-stack.png)

---

## Step 3 — Verify CloudFormation Region

When the CloudFormation console opens in your browser, check the top right corner of the AWS Management Console to confirm the active Region:

**Asia Pacific (Sydney) — `ap-southeast-2`**

Although AWS Billing capabilities are global in nature, the CloudFormation destination stack resources (S3 bucket, Glue crawler, Athena tables) must be deployed explicitly in Sydney (`ap-southeast-2`) for this workshop.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![CloudFormation in Sydney](/images/03-cur2/03-03-cloudformation-region.png)

---

## Step 4 — Stack Name

Set the CloudFormation **Stack name** to:

```text
CID-DataExports-Destination
```

This stack represents the data collection and destination infrastructure for your Cloud Intelligence Dashboards data foundation.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Destination stack details](/images/03-cur2/03-04-stack-name.png)

---

## Step 5 — Configure Common Parameters

Configure the initial set of common stack parameters as shown in the table below:

| Parameter | Workshop Value | Description |
| :--- | :--- | :--- |
| **Destination Account ID** | `<ACCOUNT_ID>` | Your 12-digit AWS Account ID |
| **Resource Prefix** | `cid` | Prefix applied to S3 buckets and Glue databases |
| **CUR 2.0** | `yes` | Enable Cost and Usage Report 2.0 exports |
| **FOCUS** | `no` | FinOps Open Cost & Usage Specification (disabled for this step) |
| **Cost Optimization Recommendations** | `no` | Disabled for initial export foundation |
| **Carbon Emissions** | `no` | Disabled for initial export foundation |
| **Source Account IDs** | `<ACCOUNT_ID>` | Your 12-digit AWS Account ID |

Because this is a single-account workshop, `Source Account IDs` equals `Destination Account ID`.

{{< note >}}
In a multi-account production environment, the source and data collection accounts may be different. This workshop intentionally uses the same account for both roles to keep the deployment focused and reproducible.
{{< /note >}}

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Common stack parameters](/images/03-cur2/03-05-common-parameters.png)

---

## Step 6 — Why CUR 2.0 is Enabled

CUR 2.0 is the primary granular cost and usage dataset used throughout this workshop. It automatically structures data exports into Parquet format partitioned by month.

```text
CUR 2.0 Export
  └── Amazon S3 (Parquet)
        └── AWS Glue Data Catalog
              └── Amazon Athena
                    └── CUDOS v5 & QuickSight
```

{{< finops title="FinOps Takeaway" >}}
Reliable FinOps analytics begins with a consistent billing and usage data foundation. CUR 2.0 provides the detailed cost and usage records that later power allocation, cost visibility, drill-down analysis, and CUDOS.
{{< /finops >}}

---

## Step 7 — Technical Parameters

Configure the technical parameters carefully according to the following matrix:

| Parameter | Workshop Value | Technical Justification |
| :--- | :--- | :--- |
| **Split Cost Allocation Data (SCAD)** | `yes` | Enables container and shared resource cost splitting |
| **IAM Principal Data** | `yes` | Provides principal context for services like Amazon Bedrock |
| **CUR 2.0 Granularity** | `HOURLY` | Delivers detailed hourly records for anomaly analysis |
| **Lake Formation** | `no` | Uses standard IAM policies rather than Lake Formation |
| **Legacy Local Bucket** | `no` | New deployment — does not use legacy CUR 1.0 S3 buckets |
| **Secondary Destination Bucket** | *Leave empty* | No cross-region secondary bucket required |
| **Blocking Write Schedule** | `no` | Allows asynchronous execution |

### Detailed Parameter Guidance

- **SCAD (`yes`)**: Retain enabled for richer cost allocation capabilities in later labs.
- **IAM Principal Data (`yes`)**: Provides additional identity attribution context where supported.
- **HOURLY Granularity**: Provides rich analytical resolution needed for deep-dive investigations and anomaly detection.
- **Lake Formation (`no`)**: Keeps authorization simple using standard AWS IAM and S3 bucket policies.
- **Legacy Local Bucket (`no`)**: Crucial setting! Verify this is set to `no` for new CUR 2.0 deployments.

{{< note >}}
For this new workshop deployment, verify that Legacy Local Bucket is set to no before continuing.
{{< /note >}}

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Technical stack parameters](/images/03-cur2/03-06-technical-parameters.png)

---

## Step 8 — Optional CloudFormation Tags

We recommend adding resource tags to track workshop infrastructure:

| Tag Key | Tag Value |
| :--- | :--- |
| `Project` | `FinOpsWorkshop` |
| `Environment` | `Workshop` |

{{< finops title="Cost Allocation Practice" >}}
Tagging workshop infrastructure provides a simple example of the same allocation discipline FinOps teams expect from production cloud workloads.
{{< /finops >}}

---

## Step 9 — Review Stack Configuration

Review the summary screen to verify all settings prior to creation:

- **Region**: `ap-southeast-2`
- **Stack Name**: `CID-DataExports-Destination`
- **CUR 2.0**: `yes`
- **Source Account ID**: `<ACCOUNT_ID>`
- **Destination Account ID**: `<ACCOUNT_ID>`
- **Legacy Local Bucket**: `no`

At the bottom of the review page, acknowledge that AWS CloudFormation may create IAM resources with custom names by selecting the capability checkbox.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Review destination stack](/images/03-cur2/03-07-review-stack.png)

---

## Step 10 — Create Stack & Monitor Progress

Click **Submit** (or **Create stack** depending on the current AWS Console UI).

Monitor the **Events** tab as CloudFormation provisions resources. Deployment normally takes several minutes.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Destination stack deployment in progress](/images/03-cur2/03-08-stack-in-progress.png)

Wait until the stack status transitions to **`CREATE_COMPLETE`**.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Destination stack complete](/images/03-cur2/03-09-stack-complete.png)

---

## Step 11 — Inspect Stack Resources

Once deployment reaches `CREATE_COMPLETE`, navigate to the **Resources** tab of the `CID-DataExports-Destination` stack to inspect created infrastructure:

- **Amazon S3**: Data collection bucket for CUR 2.0 exports (`cid-data-exports-...`).
- **AWS Glue**: Glue database and crawlers for Athena metadata registration.
- **AWS Data Exports**: Custom resource trigger creating the billing data export configuration.
- **IAM Roles & Policies**: Execution roles for Glue crawlers and EventBridge schedules.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![Destination stack resources](/images/03-cur2/03-10-stack-resources.png)

---

## Step 12 — Verify CUR 2.0 Data Export Status

Navigate to the AWS Console:

```text
AWS Console
→ Billing and Cost Management
→ Data Exports
```

Verify that the CUR 2.0 export entry (commonly named `cid-cur2` or similar prefix) is listed with an active, healthy status pointing to your destination S3 bucket.

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![CUR 2.0 export created](/images/03-cur2/03-11-cur2-export-created.png)

---

## Step 13 — Verify S3 Destination Bucket

Navigate to **Amazon S3** and locate the newly created destination bucket (e.g., `cid-data-exports-<ACCOUNT_ID>`).

{{< note >}}
The first CUR 2.0 delivery can take significant time. The absence of billing Parquet objects immediately after the CloudFormation stack completes does not necessarily indicate a deployment failure.
{{< /note >}}

<!-- TODO: Replace with screenshot captured during the real workshop execution. -->
![CUR destination bucket](/images/03-cur2/03-12-cur2-s3-bucket.png)

<!-- TODO: Replace with optional screenshot captured after CUR delivery occurs. -->
![CUR Parquet delivery](/images/03-cur2/03-13-cur2-parquet-delivery.png)

---

## Why We Do Not Deploy a Source Stack

This workshop follows the single-account path supported by the CID Data Exports deployment model:

- The destination stack in this lab creates and configures the Data Export definition directly for the local account.
- A separate "Source Stack" is only required in multi-account organizations where child accounts push billing data into a centralized management/payer account.

---

{{< cost >}}
This lab establishes resources that will be used by later modules. Review current AWS pricing before running the workshop in a personal AWS account, and remember to complete the cleanup module when finished.
{{< /cost >}}

---

{{< validation >}}
Before continuing, verify:

- The `CID-DataExports-Destination` CloudFormation stack status is `CREATE_COMPLETE`.
- The deployment Region is `ap-southeast-2` (Sydney).
- CUR 2.0 export parameter was set to `yes`.
- Your Account ID is configured for both source and destination parameters.
- A Data Export entry exists under **Billing and Cost Management → Data Exports**.
- The destination S3 bucket has been created.
- `Legacy Local Bucket` was explicitly configured as `no`.
{{< /validation >}}

---

## Troubleshooting

### Stack Deployment Fails

1. Go to **CloudFormation → Stacks → CID-DataExports-Destination → Events**.
2. Filter for `CREATE_FAILED` events to review the exact **Status reason**.
3. Verify that your IAM identity has adequate permissions to create S3 buckets, IAM roles, and Glue databases.

### No CUR Data in S3 Yet

- AWS Data Exports operates on an automated update schedule. Initial delivery of CUR 2.0 Parquet files to S3 typically takes between 6 to 24 hours.
- Verify that the Data Export status in **Billing and Cost Management** shows Healthy/Active.

### Stack Deployed in Wrong Region

- If the stack was mistakenly created in another Region (e.g. `us-east-1`), delete the stack before re-launching it in `ap-southeast-2` to prevent naming conflicts on S3 resources.

### IAM Permission Failures

- Review the specific CloudFormation event error message. Ensure your session identity has permission to pass IAM roles (`iam:PassRole`) created by the template.

---

<!--
## Evidence Checklist for Workshop Authors
Required Screenshots for Real Execution:
- [ ] 03-01-caller-identity.png
- [ ] 03-02-launch-stack.png
- [ ] 03-03-cloudformation-region.png
- [ ] 03-04-stack-name.png
- [ ] 03-05-common-parameters.png
- [ ] 03-06-technical-parameters.png
- [ ] 03-07-review-stack.png
- [ ] 03-08-stack-in-progress.png
- [ ] 03-09-stack-complete.png
- [ ] 03-10-stack-resources.png
- [ ] 03-11-cur2-export-created.png
- [ ] 03-12-cur2-s3-bucket.png
- [ ] 03-13-cur2-parquet-delivery.png (Optional until CUR delivery occurs)
-->

{{< finops title="FinOps Takeaway" >}}
This stack creates the billing-data foundation for the rest of the workshop. CUDOS and Amazon Quick do not replace CUR 2.0; they consume and interpret the cost and usage data produced by this layer. Establishing a reliable data foundation before building dashboards or AI workflows is a core FinOps engineering principle.
{{< /finops >}}

---

**Next:** [Validate CUR 2.0 delivery and inspect the S3 data foundation](../04-s3-delivery/)
