---
title: "Prerequisites"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## Required accounts and tools

Prepare these items before you start:

- AWS account with permission to create IAM, SageMaker, S3, Lambda, EventBridge, Secrets Manager, CodeConnections, and Service Catalog resources.
- GitHub account with permission to create a repository, repository secrets, and personal access token.
- AWS CLI configured locally.
- Git installed locally.
- SageMaker Studio domain. Use the new Studio experience if available in your Region.

Use one Region for the whole workshop. The AWS blog uses `us-east-1`; you can choose another supported Region, but keep all resources in the same Region.

## Create a working folder

Open a terminal and set variables:

```bash
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export GITHUB_OWNER=<your-github-user-or-org>
export GITHUB_REPO=mlops-sagemaker-github-actions-workshop
```

Clone the sample repository:

```bash
git clone https://github.com/aws-samples/mlops-sagemaker-github-actions.git
cd mlops-sagemaker-github-actions
```

## Create GitHub repository

Create an empty GitHub repository named `mlops-sagemaker-github-actions-workshop`, then push the sample code:

```bash
git remote remove origin
git remote add origin https://github.com/$GITHUB_OWNER/$GITHUB_REPO.git
git branch -M main
git push -u origin main
```

## Security baseline

Use least privilege in a real environment. This workshop uses GitHub OIDC federation from the start instead of long-lived IAM user access keys — see [GitHub and AWS setup](../3-github-aws-setup) for the OIDC provider and role setup.
