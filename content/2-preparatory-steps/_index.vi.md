---
title: "Chuẩn bị"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## Tài khoản và công cụ cần có

Chuẩn bị các mục sau trước khi bắt đầu:

- AWS account có quyền tạo IAM, SageMaker, S3, Lambda, EventBridge, Secrets Manager, CodeConnections, và Service Catalog resources.
- GitHub account có quyền tạo repository, repository secrets, và personal access token.
- AWS CLI đã cấu hình local.
- Git đã cài local.
- SageMaker Studio domain. Dùng Studio experience mới nếu Region hỗ trợ.

Dùng một Region xuyên suốt workshop. AWS blog dùng `us-east-1`; bạn có thể chọn Region khác nếu hỗ trợ, nhưng phải giữ tất cả tài nguyên trong cùng Region.

## Tạo working folder

Mở terminal và đặt biến:

```bash
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export GITHUB_OWNER=<your-github-user-or-org>
export GITHUB_REPO=mlops-sagemaker-github-actions-workshop
```

Clone sample repository:

```bash
git clone https://github.com/aws-samples/mlops-sagemaker-github-actions.git
cd mlops-sagemaker-github-actions
```

## Tạo GitHub repository

Tạo GitHub repository rỗng tên `mlops-sagemaker-github-actions-workshop`, sau đó push sample code:

```bash
git remote remove origin
git remote add origin https://github.com/$GITHUB_OWNER/$GITHUB_REPO.git
git branch -M main
git push -u origin main
```

## Baseline bảo mật

Dùng least privilege trong môi trường thật. Workshop này dùng GitHub OIDC federation ngay từ đầu, không dùng long-lived IAM user access keys — xem [Thiết lập GitHub và AWS](../3-github-aws-setup) để biết cách setup OIDC provider và role.
