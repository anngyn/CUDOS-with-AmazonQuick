---
title: "CUDOS v5 Deployment Model & Readiness Contract"
weight: 1
chapter: false
pre: "5.1 "
description: "Describe how CUDOS is deployed, which assets it creates, and what evidence is required before it is accepted."
services:
  - CUDOS v5
  - cid-cmd
  - Amazon Quick Sight
  - SPICE
---
{{< badge "CUDOS v5" >}}
{{< badge "cid-cmd" >}}
{{< badge "Amazon Quick Sight" >}}

Official reference:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/deployment-in-global-regions.html`

## Role in the project

CUDOS is the analytical product built on top of CUR and Athena. It converts billing records into executive, service, account, Region, resource, commitment, and optimization views. It is not the evidence layer itself; its credibility depends on the lineage and reconciliation established in Chapters 3 and 4.

## Deployment decision

The project uses the AWS-supported `cid-cmd` deployment path from AWS CloudShell rather than recreating the CUDOS assets manually. The deployment boundary is fixed explicitly:

| Setting | Project value |
|---|---|
| AWS Console Region | Asia Pacific (Sydney) |
| AWS Region code | `ap-southeast-2` |
| Dataset refresh timezone | `Australia/Sydney` |
| CUR database/table | `cid_data_export.cur2` |
| Athena workgroup | `primary` |

The CLI version is retained because wizard prompts and generated assets can change between releases.

## CloudShell deployment runbook

This is the operational path used for the project. Screenshots of every terminal prompt are deliberately omitted; the final assets and ingestion state are stronger evidence.

### 1. Open CloudShell in Sydney and verify identity

Select **Asia Pacific (Sydney)** in the AWS Console, open CloudShell, and run:

```bash
aws sts get-caller-identity
aws configure get region
```

Confirm the intended AWS account and redact the account ID and ARN in any published evidence. A blank value from `aws configure get region` is not automatically a failure because CloudShell follows the Console session. The deployment command below still passes `ap-southeast-2` explicitly.

{{< security >}}
CloudShell uses the current AWS Console session. Do not run `aws configure` or store long-term access keys in the terminal.
{{< /security >}}

### 2. Install and verify `cid-cmd`

```bash
python3 -m ensurepip --upgrade
pip3 install --upgrade cid-cmd
cid-cmd --help
```

If pip is already available, `ensurepip` may report that the requirement is satisfied. The useful outcome is a working `cid-cmd`, not a screenshot of the installation process.

### 3. Verify the Athena result location

CUDOS uses the `primary` workgroup to create and query its Athena views. Verify the workgroup before starting the wizard:

```bash
aws athena get-work-group \
  --work-group primary \
  --region ap-southeast-2 \
  --query "WorkGroup.Configuration.ResultConfiguration.OutputLocation" \
  --output text
```

The expected result is a Sydney bucket dedicated to Athena query output:

```text
s3://finops-workshop-athena-results-<ACCOUNT_ID>-ap-southeast-2/
```

Do not select `cid-<ACCOUNT_ID>-data-exports`; that bucket contains CUR 2.0 source data. Mixing the two purposes makes lifecycle controls and troubleshooting less reliable.

### 4. Start the CUDOS v5 deployment

```bash
cid-cmd \
  --region_name ap-southeast-2 \
  deploy \
  --dashboard-id cudos-v5
```

Passing `--region_name` prevents a shell default from creating Athena or Quick Sight assets in another Region.

### 5. Apply the project wizard selections

Prompt wording can vary by `cid-cmd` version. Use the following decisions rather than relying on prompt order:

| Wizard decision | Project selection | Why |
|---|---|---|
| Athena database | `cid_data_export` | Contains the CUR 2.0 table `cur2` |
| Athena workgroup | `primary` | Uses the validated query-result configuration |
| Athena result bucket | `finops-workshop-athena-results-<ACCOUNT_ID>-ap-southeast-2` | Keeps query results separate from CUR source data |
| Quick Sight data source | `CID-CMD-Athena <CREATE NEW DATASOURCE>` | First deployment; reuse `CID-CMD-Athena` if it already exists in Sydney |
| Quick Sight data-source role | `CidCmdQuickSightDataSourceRole <ADD NEW ROLE>` | First deployment; reuse the existing CID-managed role when present |
| Cost allocation tags | Empty, then `Looks good` | No approved business taxonomy was available in this account |
| Dataset refresh timezone | `Australia/Sydney` | Aligns the refresh schedule with the deployment location |
| Dashboard taxonomy fields | Empty, then `Looks good` | Single-account parent fields add no useful allocation context |

If `cid-cmd` proposes an updated Athena-access policy for the CID-managed role, review its resources before confirming. Do not add high-cardinality tags merely because they are discoverable; they increase dataset size and SPICE consumption without improving allocation.

At successful completion, the expected assets include `summary_view`, `resource_view`, `hourly_view`, supporting Athena views, and CUDOS Dashboard v5. Do not interrupt CloudShell while these dependencies are being created.

## Dependency chain

The deployment is valid only when these upstream conditions hold:

```text
CUR 2.0 delivered
→ Glue table points to the delivery prefix
→ Athena query succeeds
→ Quick Sight owner and source access exist
→ SPICE capacity is available
→ cid-cmd creates and refreshes CUDOS assets
```

A failure near the end of this chain is not automatically a CUDOS defect. For example, an ingestion failure can be caused by stale source permissions or insufficient SPICE capacity.

## Generated asset model

AWS currently documents CUDOS v5 around datasets such as `summary_view`, `resource_view`, and `hourly_view`. Exact asset names and sheet labels are release-dependent, so the deployed environment, `cid-cmd` version, and resulting Quick Sight assets are recorded together.

## Deployment and readiness record

```text
cid-cmd version:
Deployment timestamp:
Region:
Dashboard ID/version:
CUR database/table:
Quick Sight owner:
Generated datasets:
Latest ingestion status/time:
Final command status:
```

Dashboard availability and data freshness are separate checks. A dashboard can open while its SPICE datasets are stale or failed.

## Acceptance contract

CUDOS is accepted only when:

1. the deployment command completes successfully;
2. expected datasets and dashboard assets exist;
3. the latest SPICE ingestion succeeds;
4. the dashboard shows the intended period and metric;
5. one headline value reconciles with Athena for identical scope.

{{< capture src="images/05-cudos/05-01-cudos-datasets-spice.png" alt="Amazon Quick dataset list showing the three CUDOS v5 datasets in SPICE" title="CUDOS v5 dataset inventory" capture="Capture Amazon Quick → Data with summary_view, resource_view, and hourly_view visible and marked as SPICE. Keep the asset names and last-modified context visible; redact account and user identifiers." caption="The asset inventory proves that the three expected CUDOS datasets exist and use SPICE." >}}

{{< capture src="images/05-cudos/05-01-cudos-dashboard.png" alt="Deployed CUDOS Dashboard v5 open in Amazon Quick" title="CUDOS Dashboard v5 running in Sydney" capture="Open CUDOS Dashboard v5 and capture one usable dashboard view with its title, selected period, and visible data or an explicit current-period limitation. Include the Sydney Region context when visible; redact financial and identity details that should not be public." caption="The open dashboard proves that the analytical asset is accessible; a dashboard list alone is not required." >}}

{{< capture src="images/05-cudos/05-02-cudos-spice-ingestion.png" alt="SPICE ingestion state for the CUDOS v5 summary_view dataset" title="Latest CUDOS SPICE ingestion" capture="Open the ingestion or refresh history for summary_view and capture the latest Successful or Completed status with its timestamp. Keep the dataset name and SPICE context visible; redact internal identifiers." caption="Only Successful or Completed with a timestamp passes the freshness gate. An In progress capture documents a pending refresh and must be replaced after completion." >}}

{{< note >}}
A newly created CUR 2.0 export can contain only the current billing period. In that case, visuals for Previous Month, Two Months Ago, or Three Months Ago can show `No data` even when CUDOS is deployed correctly. The cause is insufficient billing history, not automatically a dashboard failure.
{{< /note >}}

## CUDOS-style dashboard companion

The deployed CUDOS Dashboard v5 remains the deployment asset. When its real CUR history is too limited for a useful walkthrough, the project also provides a separate **CUDOS Dashboard Demo [Synthetic]**. It runs through Amazon Quick Direct Query against `finops_demo.cudos_dashboard_demo_mock`, does not consume SPICE, and uses the same synthetic cost source as sections 6.1 and 6.2.

Its costs reconcile across the project:

```text
July total cost:      $1,180.00
AmazonEC2 driver:       $693.30
EC2 staging subset:     $135.30
6.1 measured savings:    $15.00
6.2 allocated cost:   $1,142.80
6.2 unallocated cost:    $37.20
```

{{< capture src="images/05-cudos/05-01-cudos-dashboard-demo-synthetic.png" alt="CUDOS-style Amazon Quick dashboard based on the connected synthetic cost source" title="CUDOS-style cost dashboard demonstration" capture="Create the Direct Query dashboard from CUDOS Dashboard Demo [Synthetic]. Show the July date range, total cost, daily cost trend, cost by service, and cost by owner. Keep the synthetic/demo label visible." caption="Demonstration dataset: this companion visualizes the shared synthetic source used by chapters 5 and 6. It does not replace CUDOS v5 deployment or SPICE-ingestion evidence." >}}

## Current project status

The CUR, Glue, and Athena dependencies have runtime evidence in this repository. The project also has a working Direct Query dashboard companion based on a shared synthetic source, for a complete CUDOS-style walkthrough. The CUDOS v5 deployment gate still requires its own deployment record, successful SPICE ingestion, and a reconciled real-CUR headline metric; the companion does not claim those conditions have passed.

{{< validation >}}
`Dashboard opens` is not the final success condition. The accepted state is `dashboard opens + datasets are fresh + a named metric reconciles with Athena`.
{{< /validation >}}
