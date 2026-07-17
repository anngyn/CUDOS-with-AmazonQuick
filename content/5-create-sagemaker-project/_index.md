---
title: "Create SageMaker project"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

## Open SageMaker Studio

1. Open **Amazon SageMaker** in the AWS Console.
2. Open **Studio**.
3. Select your user profile.
4. Launch Studio.

## Create project from custom template

1. In Studio, open **Deployments** or **Projects**.
2. Choose **Create project**.
3. Select the custom template published through Service Catalog (**Organization templates** tab).
4. Enter project parameters — all five fields under "Code Repository Info" are required, `CloudFormation` rejects the request before creating any resource if any are blank:

| Parameter | Example |
|---|---|
| Name | `Build-Deploy-GitHub` (must be unique in the account/Region) |
| GitHub Repository Owner Name | Your GitHub user or organization |
| GitHub Repository Name | Your workshop repository name |
| Codestar connection unique id | The UUID portion of the CodeStar/CodeConnections ARN created earlier |
| Name of the secret in Secrets Manager | `mlops` (or whatever name you used) |
| GitHub workflow file for deployment | `deploy.yml` |

5. Choose **Create project**.

If GitHub Actions workflow files live in a subfolder (for example this repo also hosts a separate Hugo site, so the MLOps code sits under `seedcode/`), the workflow YAML files themselves must still be at the repository root's `.github/workflows/` — GitHub Actions does not read workflows from a nested `.github` folder. Use `working-directory: seedcode` inside each job step instead of moving the whole pipeline code to the repo root.

## Review created resources

After provisioning finishes, validate:

- SageMaker project exists in Studio.
- Model package group exists in SageMaker Model Registry.
- GitHub repository contains workflow files.
- GitHub Actions has access to required secrets.
- Service Catalog provisioned product shows success.

## Trigger first build

Make a small commit or run workflow manually from GitHub Actions.

```bash
git commit --allow-empty -m "trigger first sagemaker pipeline run"
git push origin main
```

Open GitHub repository > **Actions** and watch the build workflow. The workflow should call AWS APIs and start SageMaker Pipeline.
