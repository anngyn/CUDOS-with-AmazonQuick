---
title: "Deploy CUDOS v5 Dashboards"
weight: 1
chapter: false
pre: "5.1 "
description: "Deploy the current CUDOS v5 dashboard with cid-cmd."
duration: "20 mins"
services:
  - CUDOS v5
  - cid-cmd
  - Amazon Quick Sight
  - SPICE
---
{{< badge "CUDOS v5" >}}
{{< badge "cid-cmd" >}}
{{< badge "Amazon Quick Sight" >}}
{{< duration "20 mins" >}}


Official reference:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/deployment-in-global-regions.html`

## Step 1 — Verify prerequisites

Before deploying:

- CUR 2.0 has been delivered.
- Athena can query the CUR table.
- Amazon Quick / Quick Sight is provisioned.
- You know the Quick Sight username.
- You are using the same Region as the Data Collection stack.

## Step 2 — Open AWS CloudShell

Open **AWS CloudShell** in Sydney.

{{< note >}}
📸 **Screenshot placeholder — `05-01-cloudshell.png`**

Capture CloudShell showing the target Region.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 3 — Install CID CLI

```bash
pip3 install --upgrade cid-cmd
```

Verify:

```bash
cid-cmd --help
```

{{< note >}}
📸 **Screenshot placeholder — `05-02-cid-cmd-installed.png`**

Capture successful `cid-cmd --help` output.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 4 — Deploy CUDOS v5

```bash
cid-cmd deploy --dashboard-id cudos-v5
```

Follow the wizard.

When prompted:

1. Use the current Data Collection account.
2. Use the CUR 2.0 source created in Module 3.
3. Use the same Region.
4. Select the Quick Sight user that owns/creates the assets.
5. Review values before confirming.

{{< note >}}
📸 **Screenshot placeholder — `05-03-cudos-deployment-wizard.png`**

Capture one wizard screen that clearly shows the selected CUR source and Region.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 5 — Wait for deployment

Do not interrupt the deployment just because it takes several minutes.

{{< note >}}
📸 **Screenshot placeholder — `05-04-cudos-deployment-complete.png`**

Capture the successful cid-cmd completion output.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 6 — Verify Quick Sight datasets

Open:

**Amazon Quick → Quick Sight → Datasets**

AWS currently documents CUDOS v5 around:

- `summary_view`
- `resource_view`
- `hourly_view`

{{< note >}}
📸 **Screenshot placeholder — `05-05-cudos-datasets.png`**

Capture the CUDOS v5 datasets.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 7 — Verify SPICE refresh

Open relevant datasets and inspect ingestion status.

{{< note >}}
📸 **Screenshot placeholder — `05-06-spice-ingestion.png`**

Capture a successful SPICE refresh or ingestion status.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

## Step 8 — Open CUDOS

Open **Dashboards → CUDOS**.

{{< note >}}
📸 **Screenshot placeholder — `05-07-cudos-home.png`**

Capture the CUDOS v5 landing/executive view using real account data.

Replace this block with the real screenshot after completing the step.
{{< /note >}}

{{< validation >}}
The deployment is complete when the CUDOS dashboard opens and its source datasets can refresh successfully.
{{< /validation >}}
