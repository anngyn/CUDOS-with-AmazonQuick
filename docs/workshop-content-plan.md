# AWS FinOps Intelligence Project — Content and Evidence Status

## Evidence policy

The project no longer asks participants to capture every console step. Evidence is retained per outcome: data delivery, query validation, CUDOS readiness, metric reconciliation, FinOps finding, allocation/unit economics, alert delivery, and cleanup.

## Current status

| Area | Source page | Status | Evidence |
|---|---|---|---|
| Data Exports deployment | `content/03-cur2-foundation/03-deploy-data-export.md` | Documented | Official launch/configuration references embedded |
| CUR 2.0 delivery | `content/03-cur2-foundation/04-validate-delivery.md` | Executed | Real Parquet delivery image embedded |
| Athena validation | `content/04-athena-integration/01-query-cur2.md` | Executed | Database, table, sample, schema, query, and scan-stat images embedded |
| Glue mapping | `content/04-athena-integration/02-glue-inspection.md` | Partially executed | Database image embedded; table-to-S3 mapping record still required |
| CUDOS v5 | `content/05-cudos-v5/` | Evidence pending | Deployment/SPICE/readiness record required |
| FinOps analysis | `content/06-finops-analysis/` | Evidence pending | Reconciled finding and measured outcome required |
| Advanced Quick/Flows | `content/08-amazon-quick-genai/`, `content/09-agentic-finops/` | Optional | Evaluation/run record required only if completed |
| Alerting and cleanup | `content/10-anomaly-detection/`, `content/12-cleanup/` | Evidence pending | Delivery test and final resource inventory required |

Before publication, review embedded screenshots for account IDs, catalog IDs, bucket names, and financial values.
