# End-to-End MLOps Pipeline with SageMaker, GitHub, and GitHub Actions

Hands-on workshop that builds a custom Amazon SageMaker project template connecting GitHub and GitHub Actions with SageMaker Pipelines, SageMaker Model Registry, staging deployment, and production approval.

Follows the AWS blog post ["Build an end-to-end MLOps pipeline using Amazon SageMaker Pipelines, GitHub, and GitHub Actions"](https://aws.amazon.com/blogs/machine-learning/build-an-end-to-end-mlops-pipeline-using-amazon-sagemaker-pipelines-github-and-github-actions/).

## Repository layout

- `seedcode/` — SageMaker pipeline code (abalone example), GitHub Actions build/deploy scripts, staging/prod config
- `.github/workflows/build.yml` — triggers SageMaker Pipeline on push to `seedcode/pipelines/**`
- `.github/workflows/deploy.yml` — deploys staging then production endpoint, manual gate via GitHub environment `production`
- `project/template.yml` — CloudFormation template for the custom SageMaker Service Catalog product
- `iam/` — IAM policies: GitHub Actions execution policy, OIDC trust policy, Service Catalog launch role add-on
- `lambda_functions/lambda_github_workflow_trigger/` — Lambda that dispatches `deploy.yml` on model approval

## Setup

1. Create a GitHub OIDC provider + IAM role in your AWS account, trust `repo:<owner>/<repo>:*`, attach `iam/GithubActionsMLOpsExecutionPolicy.json`.
2. Add repository secret `AWS_DEPLOY_ROLE_ARN` with that role's ARN. No long-lived AWS access keys.
3. Create a GitHub environment named `production` with a required reviewer.
4. Build and publish the Lambda layer (arm64, python3.12) used by the GitHub-trigger Lambda.
5. Upload `project/template.yml` and the Lambda code zip to an S3 bucket with a `sagemaker-*` prefix (required by the default Service Catalog launch role permissions).
6. Publish `project/template.yml` as a Service Catalog product, tag it `sagemaker:studio-visibility=true`.
7. In SageMaker Studio, create a project from the published template, filling in GitHub owner/repo, CodeStar connection id, Secrets Manager secret name, and deploy workflow filename.

Full walkthrough is published as a Hugo site under `content/`.

## Workshop site (Hugo)

```bash
hugo server -D
```

Open `http://localhost:1313`. Deployed automatically to GitHub Pages on push to `main`/`update` via `.github/workflows/hugo-pages.yml`.
