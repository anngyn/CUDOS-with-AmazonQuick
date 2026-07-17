---
title: "GitHub and AWS setup"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

## Create CodeConnections connection

1. Open the AWS Console.
2. Go to **Developer Tools** > **Settings** > **Connections**.
3. Choose **Create connection**.
4. Provider: **GitHub**.
5. Connection name: `github-mlops-connection`.
6. Complete GitHub authorization and install the connector on your repository or organization.
7. Copy the connection ARN.

Set the value locally:

```bash
export CODECONNECTION_ARN=<connection-arn>
```

## Create GitHub personal access token

Create a GitHub fine-grained token or classic token with access to the workshop repository. It must be able to trigger workflow dispatch events.

Save the token in Secrets Manager:

```bash
aws secretsmanager create-secret \
  --name mlops \
  --secret-string '{"token":"<github-token>"}' \
  --region $AWS_REGION
```

## Create an IAM OIDC provider and role for GitHub Actions

Do not use long-lived IAM user access keys. Create an OIDC identity provider trusting `token.actions.githubusercontent.com`, then an IAM role GitHub Actions can assume:

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

aws iam create-role \
  --role-name GitHubActionsMLOpsExecutionRole \
  --assume-role-policy-document file://iam/GitHubActionsTrustPolicy.json

aws iam put-role-policy \
  --role-name GitHubActionsMLOpsExecutionRole \
  --policy-name GithubActionsMLOpsExecutionPolicy \
  --policy-document file://iam/GithubActionsMLOpsExecutionPolicy.json
```

The trust policy in `iam/GitHubActionsTrustPolicy.json` restricts `sts:AssumeRoleWithWebIdentity` to `repo:<owner>/<repo>:*`. Update it to match your GitHub owner and repository name.

## Add GitHub repository secret

![GitHub repository secrets](/images/mlops-sagemaker-github-actions/github-secrets.svg)

In GitHub, open your repository:

1. Go to **Settings** > **Secrets and variables** > **Actions**.
2. Add one repository secret:

| Secret name | Value |
|---|---|
| `AWS_DEPLOY_ROLE_ARN` | ARN of `GitHubActionsMLOpsExecutionRole` |

No AWS access key or secret key is stored in GitHub — `aws-actions/configure-aws-credentials` assumes the role via OIDC at workflow run time.

3. Go to **Settings** > **Environments**, create an environment named `production`, and add yourself as a required reviewer. This is the manual approval gate before the production endpoint deploys.

## Validate setup

Confirm access from your terminal:

```bash
aws sts get-caller-identity
aws codestar-connections list-connections --region $AWS_REGION
aws secretsmanager describe-secret --secret-id mlops --region $AWS_REGION
```
