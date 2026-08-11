# Connected FinOps Demonstration Data

## Purpose

This is an isolated, synthetic demonstration path used when the real CUR 2.0 export has insufficient history for CUDOS walkthroughs. It does not replace the deployed CUDOS v5 datasets, SPICE ingestion, or real billing evidence.

## Single source and derived views

```text
finops_connected_demo_source_mock (31 days × 6 workloads = 186 cost rows)
        ├── cudos_dashboard_demo_mock        → chapters 5.1 and 5.2
        ├── finops_optimization_outcome_mock → chapter 6.1
        └── finops_unit_economics_mock        → chapter 6.2
```

The source is created by:

```text
static/data/mock/create-finops-connected-demo-source.sql
```

All views use Athena in `ap-southeast-2` and Amazon Quick `DIRECT_QUERY` through `CID-CMD-Athena`. No SPICE capacity is required.

## Reconciliation values

| Scope | Derived result | Why it matters |
|---|---:|---|
| July synthetic cloud cost | `$1,180.00` | CUDOS-style dashboard headline |
| AmazonEC2 | `$693.30` | Top service driver in chapters 5.1 and 5.2 |
| EC2 staging | `$135.30` | The workload considered in the optimization case |
| Baseline period | `$42.00` | 1–7 July, staging EC2 |
| Measurement period | `$27.00` | 8–14 July, staging EC2 |
| Realized savings | `$15.00` / `35.71%` | Chapter 6.1 outcome |
| Allocated cost | `$1,142.80` | All source cost except shared data transfer |
| Unallocated cost | `$37.20` | Shared data transfer |
| Allocation coverage | `96.85%` | `$1,142.80 / $1,180.00` |
| Inference API workload | `$99.20` | AWS Lambda source cost |
| Business denominator | `49,600` successful inference requests | Synthetic, governed denominator |
| Cost per 1,000 requests | `$2.00` | `$99.20 / 49,600 × 1,000` |

## Amazon Quick datasets created through AWS CLI

| Dataset name | Athena view | Intended evidence |
|---|---|---|
| `CUDOS Dashboard Demo [Synthetic]` | `cudos_dashboard_demo_mock` | 5.1 / 5.2 dashboard walkthrough |
| `FinOps Allocation and Unit Economics [Synthetic]` | `finops_unit_economics_mock` | 6.2 allocation and unit-cost dashboard |
| `finops_optimization_outcome_mock` | `finops_optimization_outcome_mock` | 6.1 optimization outcome dashboard |

## Images still required

Only these project screenshots need to be captured for the synthetic path:

```text
static/images/05-cudos/05-01-cudos-dashboard-demo-synthetic.png
static/images/06-finops-analysis/06-02-allocation-unit-economics.png
```

Each screenshot must keep the `Synthetic` or `Demonstration dataset` label visible.
