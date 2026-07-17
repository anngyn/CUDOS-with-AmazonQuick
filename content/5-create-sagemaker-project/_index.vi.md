---
title: "Tạo SageMaker project"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

## Mở SageMaker Studio

1. Mở **Amazon SageMaker** trong AWS Console.
2. Mở **Studio**.
3. Chọn user profile.
4. Launch Studio.

## Tạo project từ custom template

1. Trong Studio, mở **Deployments** hoặc **Projects**.
2. Chọn **Create project**.
3. Chọn custom template đã publish qua Service Catalog (tab **Organization templates**).
4. Nhập project parameters — cả 5 field trong "Code Repository Info" đều bắt buộc, CloudFormation reject request trước khi tạo bất kỳ resource nào nếu bỏ trống ô nào:

| Parameter | Example |
|---|---|
| Name | `Build-Deploy-GitHub` (phải unique trong account/Region) |
| GitHub Repository Owner Name | GitHub user hoặc organization của bạn |
| GitHub Repository Name | Tên repository workshop của bạn |
| Codestar connection unique id | Phần UUID trong ARN CodeStar/CodeConnections đã tạo trước đó |
| Name of the secret in Secrets Manager | `mlops` (hoặc tên bạn đã đặt) |
| GitHub workflow file for deployment | `deploy.yml` |

5. Chọn **Create project**.

Nếu GitHub Actions workflow file nằm trong subfolder (ví dụ repo này còn host một Hugo site riêng, nên code MLOps nằm trong `seedcode/`), file YAML workflow vẫn phải nằm ở `.github/workflows/` tại root repository — GitHub Actions không đọc workflow từ `.github` nằm trong subfolder. Dùng `working-directory: seedcode` trong từng step của job thay vì move toàn bộ pipeline code lên root repo.

## Kiểm tra tài nguyên đã tạo

Sau khi provisioning hoàn tất, xác nhận:

- SageMaker project tồn tại trong Studio.
- Model package group tồn tại trong SageMaker Model Registry.
- GitHub repository có workflow files.
- GitHub Actions có đủ repository secrets.
- Service Catalog provisioned product thành công.

## Trigger build đầu tiên

Tạo commit nhỏ hoặc chạy workflow thủ công từ GitHub Actions.

```bash
git commit --allow-empty -m "trigger first sagemaker pipeline run"
git push origin main
```

Mở GitHub repository > **Actions** và theo dõi build workflow. Workflow cần gọi AWS APIs và start SageMaker Pipeline.
