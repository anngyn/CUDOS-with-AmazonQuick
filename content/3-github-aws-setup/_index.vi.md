---
title: "Thiết lập GitHub và AWS"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

## Tạo CodeConnections connection

1. Mở AWS Console.
2. Vào **Developer Tools** > **Settings** > **Connections**.
3. Chọn **Create connection**.
4. Provider: **GitHub**.
5. Connection name: `github-mlops-connection`.
6. Hoàn tất GitHub authorization và cài connector cho repository hoặc organization.
7. Copy connection ARN.

Đặt giá trị local:

```bash
export CODECONNECTION_ARN=<connection-arn>
```

## Tạo GitHub personal access token

Tạo GitHub fine-grained token hoặc classic token có quyền truy cập workshop repository. Token cần quyền trigger workflow dispatch events.

Lưu token vào Secrets Manager:

```bash
aws secretsmanager create-secret \
  --name mlops \
  --secret-string '{"token":"<github-token>"}' \
  --region $AWS_REGION
```

## Tạo IAM OIDC provider và role cho GitHub Actions

Không dùng long-lived IAM user access keys. Tạo OIDC identity provider trust `token.actions.githubusercontent.com`, sau đó tạo IAM role để GitHub Actions assume:

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

Trust policy trong `iam/GitHubActionsTrustPolicy.json` giới hạn `sts:AssumeRoleWithWebIdentity` cho `repo:<owner>/<repo>:*`. Sửa lại đúng GitHub owner và tên repository của bạn.

## Thêm GitHub repository secret

![GitHub repository secrets](/images/mlops-sagemaker-github-actions/github-secrets.svg)

Trong GitHub, mở repository:

1. Vào **Settings** > **Secrets and variables** > **Actions**.
2. Thêm một repository secret:

| Secret name | Value |
|---|---|
| `AWS_DEPLOY_ROLE_ARN` | ARN của `GitHubActionsMLOpsExecutionRole` |

Không lưu access key/secret key AWS nào trong GitHub — `aws-actions/configure-aws-credentials` assume role qua OIDC ngay khi workflow chạy.

3. Vào **Settings** > **Environments**, tạo environment tên `production`, thêm bạn làm required reviewer. Đây là bước duyệt tay trước khi deploy production endpoint.

## Kiểm tra setup

Xác nhận access từ terminal:

```bash
aws sts get-caller-identity
aws codestar-connections list-connections --region $AWS_REGION
aws secretsmanager describe-secret --secret-id mlops --region $AWS_REGION
```
