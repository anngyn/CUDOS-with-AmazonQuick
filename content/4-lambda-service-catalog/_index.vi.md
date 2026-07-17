---
title: "Lambda và Service Catalog"
weight: 4
chapter: false
pre: " <b> 4. </b> "
---

## Mục đích

Phần này tạo lớp kết nối theo mẫu trong AWS blog:

- Lambda layer chứa Python dependency dùng để gọi GitHub APIs.
- Lambda function nhận EventBridge events từ SageMaker Model Registry.
- Service Catalog product hiển thị custom SageMaker project template trong Studio.

## Tạo Lambda layer

Lambda trigger (`lambda_functions/lambda_github_workflow_trigger/lambda_function.py`) cần `boto3` và `pygithub`. Phải build layer đúng **platform target** (`linux/arm64`, Python 3.12) — build local trên Windows/macOS sẽ tạo native extension (`cffi`, `cryptography`) sai OS/architecture, chạy lên Lambda sẽ lỗi `Runtime.ImportModuleError`.

Dùng Docker build đúng platform dù host là OS khác:

```bash
mkdir -p lambda_layer_build/python
docker run --rm \
  -v "$(pwd)/lambda_layer_build/python:/out/python" \
  -v "$(pwd)/lambda_functions/lambda_github_workflow_trigger/requirements.txt:/requirements.txt" \
  public.ecr.aws/sam/build-python3.12:latest \
  /bin/bash -c "pip install -r /requirements.txt -t /out/python --no-cache-dir --platform manylinux2014_aarch64 --python-version 3.12 --implementation cp --only-binary=:all:"

cd lambda_layer_build && zip -r -q layer.zip python && cd ..
```

Publish layer (không cần upload S3, `publish-layer-version` nhận file trực tiếp):

```bash
aws lambda publish-layer-version \
  --layer-name python312-github-arm64 \
  --zip-file fileb://lambda_layer_build/layer.zip \
  --compatible-runtimes python3.12 \
  --compatible-architectures arm64 \
  --region $AWS_REGION
```

Copy layer version ARN — `project/template.yml` đã reference sẵn `python312-github-arm64:1` trong property `Layers` của `GitHubWorkflowTriggerLambda`.

## Upload Lambda code zip lên S3 bucket

`AmazonSageMakerServiceCatalogProductsLaunchRole` (role Service Catalog dùng chạy CloudFormation template) chỉ cấp `s3:GetObject` cho bucket khớp prefix **`sagemaker-*`** — quy định trong managed policy `AmazonSageMakerAdmin-ServiceCatalogProductsServiceRolePolicy`. Nếu bucket bạn không bắt đầu bằng `sagemaker-`, Lambda sẽ `CREATE_FAILED` với lỗi S3 `AccessDenied`.

```bash
aws s3 mb s3://sagemaker-<suffix-cua-ban> --region $AWS_REGION
cd lambda_functions/lambda_github_workflow_trigger
zip -r lambda-github-workflow-trigger.zip lambda_function.py
aws s3 cp lambda-github-workflow-trigger.zip s3://sagemaker-<suffix-cua-ban>/lambda-github-workflow-trigger.zip
cd ../..
```

Sửa `project/template.yml` field `Code.S3Bucket` khớp tên bucket của bạn.

## Thêm lambda:GetLayerVersion cho launch role

Managed policy trên không cấp `lambda:GetLayerVersion`, nên vẫn `CREATE_FAILED` với `AccessDenied` trên action này dù bucket và layer đã đúng. Thêm inline policy nhỏ cho launch role (xem `iam/ServiceCatalogLambdaLayerAccessPolicy.json`):

```bash
aws iam put-role-policy \
  --role-name AmazonSageMakerServiceCatalogProductsLaunchRole \
  --policy-name AllowGithubMLOpsLambdaLayerAccess \
  --policy-document file://iam/ServiceCatalogLambdaLayerAccessPolicy.json
```

## Tạo EventBridge rule

CloudFormation template đã định nghĩa sẵn rule này (`ModelDeploySageMakerEventRule`) — lắng nghe SageMaker Model Package state change khi `ModelApprovalStatus` là `Approved`, target Lambda trigger. Không cần làm tay khi stack đã deploy.

## Publish Service Catalog product

![Service Catalog custom template](/images/mlops-sagemaker-github-actions/service-catalog.svg)

Upload `project/template.yml` lên bucket `sagemaker-*` và tạo product:

```bash
aws s3 cp project/template.yml s3://sagemaker-<suffix-cua-ban>/template.yml

aws servicecatalog create-product \
  --name build-deploy-github \
  --owner "<ten-cua-ban>" \
  --product-type CLOUD_FORMATION_TEMPLATE \
  --provisioning-artifact-parameters \
    Name=v1,Type=CLOUD_FORMATION_TEMPLATE,Info="{\"LoadTemplateFromURL\":\"https://sagemaker-<suffix-cua-ban>.s3.$AWS_REGION.amazonaws.com/template.yml\"}"
```

Tag product `sagemaker:studio-visibility=true` và associate với portfolio SageMaker Studio dùng.

Nếu sửa `template.yml` sau này, phải tạo **provisioning artifact version mới** — Service Catalog không tự đọc lại cùng object S3; sửa file tại chỗ không ảnh hưởng version đã tạo trước:

```bash
aws servicecatalog create-provisioning-artifact \
  --product-id <product-id> \
  --parameters '{"Name":"v2","Info":{"LoadTemplateFromURL":"https://sagemaker-<suffix-cua-ban>.s3.'$AWS_REGION'.amazonaws.com/template.yml"},"Type":"CLOUD_FORMATION_TEMPLATE"}'
```
