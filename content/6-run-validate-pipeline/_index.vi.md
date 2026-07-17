---
title: "Chạy và kiểm tra pipeline"
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

## Theo dõi GitHub Actions build

Mở repository trong GitHub, rồi chọn **Actions**. Build workflow cần:

1. Checkout source code.
2. Configure AWS credentials từ repository secrets.
3. Create hoặc update SageMaker Pipeline.
4. Start SageMaker Pipeline execution.

Nếu workflow lỗi, kiểm tra:

- Giá trị `AWS_REGION` khớp Region bạn deploy SageMaker project.
- IAM role sau `AWS_DEPLOY_ROLE_ARN` có trust policy đúng repo và đã attach execution policy.
- `SAGEMAKER_PROJECT_NAME` trong workflow env khớp đúng tên project thật trong SageMaker Studio.
- S3 bucket access.
- SageMaker execution role.

## Theo dõi SageMaker Pipeline

![SageMaker pipeline approval](/images/mlops-sagemaker-github-actions/pipeline-approval.svg)

Trong SageMaker Studio:

1. Mở **Pipelines**.
2. Chọn pipeline do project tạo.
3. Mở execution mới nhất.
4. Kiểm tra từng step.

Các stage kỳ vọng:

- Processing hoặc data preparation.
- Training.
- Evaluation.
- Register model.

## Approve model

Mở **Model Registry** và chọn model package group do project tạo.

1. Mở model package mới nhất.
2. Kiểm tra metrics và artifacts.
3. Đổi approval status thành **Approved**.

Approval sẽ trigger EventBridge, sau đó Lambda, sau đó GitHub Actions deployment workflow.

## Kiểm tra deployment workflow

Quay lại GitHub **Actions** và mở deployment workflow run.

Workflow cần deploy hoặc update:

- Staging SageMaker endpoint.
- Production endpoint sau manual approval, tùy cấu hình workflow trong repository.

## Test endpoint

Dùng SageMaker runtime để invoke endpoint:

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

| Triệu chứng | Kiểm tra |
|---|---|
| GitHub workflow không dùng được credentials | Giá trị secret `AWS_DEPLOY_ROLE_ARN`, trust policy OIDC đúng repo, job có `permissions: id-token: write` |
| Push code nhưng workflow không bao giờ chạy | Workflow YAML phải nằm ở root `.github/workflows/`, không phải subfolder |
| Pipeline không được tạo | SageMaker execution role và workflow logs |
| Pipeline execution step fail `SAGEMAKER_RESOURCE_LIMIT` / instance quota = 0 | Request tăng Service Quotas cho instance type dùng (ví dụ `ml.m5.xlarge for processing job usage` và `ml.m5.xlarge for training job usage`) — account mới mặc định = 0 |
| Approve model không trigger deploy | EventBridge rule, Lambda logs, secret name |
| Lambda nhận event nhưng GitHub workflow không chạy | GitHub token permissions và workflow file name |
| Endpoint deployment lỗi | Instance quota, model artifact path, endpoint config logs |
