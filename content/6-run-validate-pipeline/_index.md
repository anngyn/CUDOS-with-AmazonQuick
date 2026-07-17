---
title: "Run and validate pipeline"
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

## Monitor GitHub Actions build

Open your repository in GitHub, then choose **Actions**. The build workflow should:

1. Check out source code.
2. Configure AWS credentials from repository secrets.
3. Create or update SageMaker Pipeline.
4. Start SageMaker Pipeline execution.

If the workflow fails, check:

- `AWS_REGION` value matches the Region you deployed the SageMaker project in.
- The IAM role behind `AWS_DEPLOY_ROLE_ARN` has the trust policy scoped to your repo and the execution policy attached.
- `SAGEMAKER_PROJECT_NAME` in the workflow env block matches the actual project name in SageMaker Studio.
- S3 bucket access.
- SageMaker execution role.

## Monitor SageMaker Pipeline

![SageMaker pipeline approval](/images/mlops-sagemaker-github-actions/pipeline-approval.svg)

In SageMaker Studio:

1. Open **Pipelines**.
2. Select the pipeline created by the project.
3. Open the latest execution.
4. Validate each step.

Expected stages:

- Processing or data preparation.
- Training.
- Evaluation.
- Register model.

## Approve model

Open **Model Registry** and select the model package group created by the project.

1. Open the latest model package.
2. Review metrics and artifacts.
3. Change approval status to **Approved**.

Approval triggers EventBridge, then Lambda, then GitHub Actions deployment workflow.

## Validate deployment workflow

Return to GitHub **Actions** and open the deployment workflow run.

The workflow should deploy or update:

- Staging SageMaker endpoint.
- Production endpoint after manual approval, depending on repository workflow configuration.

## Test endpoint

Use SageMaker runtime to invoke the endpoint:

```bash
aws sagemaker-runtime invoke-endpoint \
  --endpoint-name <endpoint-name> \
  --content-type text/csv \
  --body fileb://sample-payload.csv \
  output.json \
  --region $AWS_REGION
cat output.json
```

## Troubleshooting

| Symptom | Check |
|---|---|
| GitHub workflow cannot assume or use credentials | `AWS_DEPLOY_ROLE_ARN` secret value, OIDC trust policy repo condition, `permissions: id-token: write` on the job |
| Workflow never triggers on push | Workflow YAML must live in the repo root `.github/workflows/`, not a nested subfolder |
| Pipeline not created | SageMaker execution role and workflow logs |
| Pipeline execution step fails with `SAGEMAKER_RESOURCE_LIMIT` / instance quota is 0 | Request a Service Quotas increase for the instance type used (for example `ml.m5.xlarge for processing job usage` and `ml.m5.xlarge for training job usage`) — new accounts default to 0 |
| Model approval does not trigger deploy | EventBridge rule, Lambda logs, secret name |
| Lambda receives event but GitHub workflow does not start | GitHub token permissions and workflow file name |
| Endpoint deployment fails | Instance quota, model artifact path, endpoint config logs |
