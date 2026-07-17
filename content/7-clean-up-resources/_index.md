---
title: "Clean up resources"
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

## Delete SageMaker endpoints

Delete production and staging endpoints first to stop hourly charges:

```bash
aws sagemaker list-endpoints --region $AWS_REGION
aws sagemaker delete-endpoint --endpoint-name <endpoint-name> --region $AWS_REGION
aws sagemaker delete-endpoint-config --endpoint-config-name <endpoint-config-name> --region $AWS_REGION
```

## Delete SageMaker project resources

In SageMaker Studio:

1. Open **Projects**.
2. Select the workshop project.
3. Delete project resources if Studio exposes cleanup.

In CloudFormation, delete stacks created by the SageMaker project and Service Catalog provisioned product.

## Delete Service Catalog resources

Delete provisioned product, product, and portfolio association created for the custom template.

## Delete Lambda and EventBridge

```bash
aws events list-rules --region $AWS_REGION
aws lambda list-functions --region $AWS_REGION
aws lambda delete-function --function-name <lambda-function-name> --region $AWS_REGION
```

Delete Lambda layer versions if no longer needed.

## Delete secrets, IAM role, and OIDC provider

```bash
aws secretsmanager delete-secret \
  --secret-id mlops \
  --force-delete-without-recovery \
  --region $AWS_REGION

aws iam delete-role-policy --role-name GitHubActionsMLOpsExecutionRole --policy-name GithubActionsMLOpsExecutionPolicy
aws iam delete-role --role-name GitHubActionsMLOpsExecutionRole
aws iam delete-open-id-connect-provider \
  --open-id-connect-provider-arn arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com
```

Also remove the inline policy added to the launch role during setup:

```bash
aws iam delete-role-policy \
  --role-name AmazonSageMakerServiceCatalogProductsLaunchRole \
  --policy-name AllowGithubMLOpsLambdaLayerAccess
```

## Delete GitHub secret

In GitHub repository settings, delete `AWS_DEPLOY_ROLE_ARN`.

## Final verification

Check for remaining cost sources:

- SageMaker endpoints.
- SageMaker training and processing jobs.
- CloudFormation stacks.
- S3 buckets and artifacts.
- Lambda functions and layers.
- Secrets Manager secrets.
- CodeConnections connection.
