---
title: "Lambda and Service Catalog"
weight: 4
chapter: false
pre: " <b> 4. </b> "
---

## Purpose

This section creates the glue layer used by the AWS blog pattern:

- Lambda layer contains the Python dependency used to call GitHub APIs.
- Lambda function receives EventBridge events from SageMaker Model Registry.
- Service Catalog product exposes the custom SageMaker project template in Studio.

## Create Lambda layer

The trigger Lambda (`lambda_functions/lambda_github_workflow_trigger/lambda_function.py`) needs `boto3` and `pygithub`. Build the layer for the **exact target platform** (`linux/arm64`, Python 3.12) — building it locally on Windows or macOS produces native extensions (`cffi`, `cryptography`) for the wrong OS/architecture, which fails at runtime with `Runtime.ImportModuleError`.

Use Docker to build against the right platform even from a different host OS:

```bash
mkdir -p lambda_layer_build/python
docker run --rm \
  -v "$(pwd)/lambda_layer_build/python:/out/python" \
  -v "$(pwd)/lambda_functions/lambda_github_workflow_trigger/requirements.txt:/requirements.txt" \
  public.ecr.aws/sam/build-python3.12:latest \
  /bin/bash -c "pip install -r /requirements.txt -t /out/python --no-cache-dir --platform manylinux2014_aarch64 --python-version 3.12 --implementation cp --only-binary=:all:"

cd lambda_layer_build && zip -r -q layer.zip python && cd ..
```

Publish the layer to a bucket-independent Lambda layer resource (no S3 upload needed for `publish-layer-version`):

```bash
aws lambda publish-layer-version \
  --layer-name python312-github-arm64 \
  --zip-file fileb://lambda_layer_build/layer.zip \
  --compatible-runtimes python3.12 \
  --compatible-architectures arm64 \
  --region $AWS_REGION
```

Copy the layer version ARN — `project/template.yml` already references `python312-github-arm64:1` in the `Layers` property of `GitHubWorkflowTriggerLambda`.

## Upload the Lambda code zip to an S3 bucket

The `AmazonSageMakerServiceCatalogProductsLaunchRole` (the role Service Catalog uses to run the CloudFormation template) only grants `s3:GetObject` on buckets matching the **`sagemaker-*`** name prefix — this comes from the AWS-managed policy `AmazonSageMakerAdmin-ServiceCatalogProductsServiceRolePolicy`. If your S3 bucket doesn't start with `sagemaker-`, the Lambda `CREATE_FAILED` with an S3 `AccessDenied` error.

```bash
aws s3 mb s3://sagemaker-<your-suffix> --region $AWS_REGION
cd lambda_functions/lambda_github_workflow_trigger
zip -r lambda-github-workflow-trigger.zip lambda_function.py
aws s3 cp lambda-github-workflow-trigger.zip s3://sagemaker-<your-suffix>/lambda-github-workflow-trigger.zip
cd ../..
```

Update `project/template.yml` `Code.S3Bucket` to match your bucket name.

## Add lambda:GetLayerVersion to the Service Catalog launch role

The same managed policy above does not grant `lambda:GetLayerVersion`, so `CREATE_FAILED` on the Lambda resource with `AccessDenied` on that action even after the layer and bucket are correct. Add a small inline policy to the launch role (see `iam/ServiceCatalogLambdaLayerAccessPolicy.json`):

```bash
aws iam put-role-policy \
  --role-name AmazonSageMakerServiceCatalogProductsLaunchRole \
  --policy-name AllowGithubMLOpsLambdaLayerAccess \
  --policy-document file://iam/ServiceCatalogLambdaLayerAccessPolicy.json
```

## Create EventBridge rule

The CloudFormation template already defines this rule (`ModelDeploySageMakerEventRule`) — it listens for SageMaker Model Package state changes where `ModelApprovalStatus` is `Approved`, and targets the trigger Lambda. No manual step needed once the stack deploys.

## Publish Service Catalog product

![Service Catalog custom template](/images/mlops-sagemaker-github-actions/service-catalog.svg)

Upload `project/template.yml` to your `sagemaker-*` bucket and create the product:

```bash
aws s3 cp project/template.yml s3://sagemaker-<your-suffix>/template.yml

aws servicecatalog create-product \
  --name build-deploy-github \
  --owner "<your-name>" \
  --product-type CLOUD_FORMATION_TEMPLATE \
  --provisioning-artifact-parameters \
    Name=v1,Type=CLOUD_FORMATION_TEMPLATE,Info="{\"LoadTemplateFromURL\":\"https://sagemaker-<your-suffix>.s3.$AWS_REGION.amazonaws.com/template.yml\"}"
```

Tag the product `sagemaker:studio-visibility=true` and associate it with the portfolio used by SageMaker Studio.

If you edit `template.yml` later, create a **new provisioning artifact version** — Service Catalog does not re-read the same S3 object; updating the file in place has no effect on already-created versions:

```bash
aws servicecatalog create-provisioning-artifact \
  --product-id <product-id> \
  --parameters '{"Name":"v2","Info":{"LoadTemplateFromURL":"https://sagemaker-<your-suffix>.s3.'$AWS_REGION'.amazonaws.com/template.yml"},"Type":"CLOUD_FORMATION_TEMPLATE"}'
```
