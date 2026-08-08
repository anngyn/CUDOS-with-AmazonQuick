---
title: "Quick Sight Account Onboarding"
weight: 2
chapter: false
pre: "2.2 "
description: "Create or verify the Amazon Quick account and Quick Sight BI environment."
duration: "10 mins"
services:
  - Amazon Quick
  - Amazon Quick Sight
  - SPICE
---
{{< badge "Amazon Quick" >}}
{{< badge "Amazon Quick Sight" >}}
{{< badge "SPICE" >}}
{{< duration "10 mins" >}}

# Quick Sight Account Onboarding

Amazon Quick Sight is the BI capability used by CUDOS. It is part of Amazon Quick.

## Step 1 — Open Amazon Quick

In the AWS Management Console:

1. Confirm the Region is **Asia Pacific (Sydney)**.
2. Search for **Amazon Quick**.
3. Open the service.

{{< note >}}
📸 **Screenshot placeholder — `02-04-amazon-quick-home.png`**

Capture the Amazon Quick landing or sign-up screen in the Sydney Region.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 2 — Sign up if required

If the account is not provisioned yet:

1. Start the sign-up workflow.
2. Choose the Region where the dashboards will be deployed.
3. Enter a unique Quick account name.
4. Enter the notification email address.
5. Choose the authentication method appropriate to the workshop account.
6. Create the account and wait until onboarding completes.

For a production organization, consider IAM Identity Center for organization-wide sharing. Choose the authentication model carefully.

{{< note >}}
📸 **Screenshot placeholder — `02-05-quick-account-configuration.png`**

Capture the sign-up configuration before creating the Quick account. Redact email addresses before publishing.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Verify Quick Sight BI

Open the BI area and confirm you can access:

- Datasets
- Analyses
- Dashboards

{{< note >}}
📸 **Screenshot placeholder — `02-06-quick-sight-home.png`**

Capture the Quick Sight home area showing the BI navigation.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Review SPICE capacity

Open Quick administration and inspect SPICE capacity. CUDOS v5 uses SPICE-backed datasets. Record the current state and adjust only if the CUDOS deployment reports insufficient capacity.

{{< note >}}
📸 **Screenshot placeholder — `02-07-spice-capacity.png`**

Capture the SPICE capacity page before CUDOS deployment.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< cost >}}
Quick Sight/SPICE and advanced Amazon Quick capabilities can incur charges. Record what you enable so it can be reviewed in Module 12.
{{< /cost >}}

## Official references

- https://docs.aws.amazon.com/quick/latest/userguide/getting-started.html
- https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/deployment-in-global-regions.html
