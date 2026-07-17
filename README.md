# End-to-End MLOps Pipeline with SageMaker, GitHub, and GitHub Actions

A reference implementation of a GitHub-native MLOps pipeline for Amazon SageMaker — model training, evaluation, registry-gated approval, and staged deployment, all driven by GitHub Actions instead of AWS-native CI/CD tooling.

Based on the AWS blog post ["Build an end-to-end MLOps pipeline using Amazon SageMaker Pipelines, GitHub, and GitHub Actions"](https://aws.amazon.com/blogs/machine-learning/build-an-end-to-end-mlops-pipeline-using-amazon-sagemaker-pipelines-github-and-github-actions/), adapted and hardened for a real AWS account: OIDC-based auth instead of long-lived keys, current GitHub Actions versions, and fixes for several IAM/S3 permission gaps in the original AWS sample.

## Why this exists

Teams already living in GitHub don't want a second CI/CD system just for ML. This pipeline keeps GitHub as the single source of truth for both application code and ML pipeline code, while SageMaker stays purely the execution engine for training, evaluation, and hosting — no CodePipeline, no CodeBuild.

## Architecture

```
push to main ──▶ GitHub Actions (build.yml) ──▶ SageMaker Pipeline
                                                   │
                                    preprocess → train → evaluate
                                                   │
                                                   ▼
                                        SageMaker Model Registry
                                                   │
                                      (human approves the model)
                                                   ▼
                                     EventBridge ──▶ Lambda
                                                   │
                                                   ▼
                              GitHub Actions (deploy.yml) dispatched
                                                   │
                                      staging endpoint ──▶ tests
                                                   │
                                    (required reviewer approves)
                                                   ▼
                                          production endpoint
```

## Highlights

- **GitHub as the control plane** — a repo push starts training; a Model Registry approval starts deployment. No polling, no manual CLI steps in between.
- **Two-stage deployment with a real approval gate** — staging deploys automatically, production requires a GitHub Environment reviewer to sign off.
- **OIDC, not access keys** — GitHub Actions assumes an IAM role via short-lived federated credentials; nothing long-lived sits in repository secrets.
- **Self-contained toolchain** — a custom SageMaker Project template (via Service Catalog) provisions the Lambda trigger, EventBridge rule, and artifact bucket in one shot from SageMaker Studio.
- **Built for a real account, not just a demo** — includes the IAM policy fixes, correct-architecture Lambda layer build, and bucket-naming constraints needed to actually get `CREATE_COMPLETE` on a fresh AWS account.

## Use cases

- Teams standardizing ML delivery on the same GitHub Actions pipelines already used for application code.
- Workshops/onboarding for engineers learning SageMaker Pipelines + Model Registry without adopting AWS-native CI/CD.
- A starting point for a production MLOps pipeline that needs staged rollout with human-in-the-loop approval before hitting production.

## Repository layout

- `seedcode/` — SageMaker pipeline code (abalone example), deployment scripts, staging/prod configs
- `.github/workflows/` — `build.yml` (train) and `deploy.yml` (staging → production)
- `project/template.yml` — CloudFormation template for the custom SageMaker Service Catalog product
- `iam/` — IAM policies for the GitHub Actions role, OIDC trust policy, and Service Catalog launch role fix
- `lambda_functions/lambda_github_workflow_trigger/` — Lambda that dispatches `deploy.yml` on model approval
- `content/` — the full setup walkthrough, published as a Hugo site (EN/VI)

## Workshop site

```bash
hugo server -D
```

Open `http://localhost:1313` for the step-by-step setup guide. Deploys automatically to GitHub Pages on push to `main`/`update`.
