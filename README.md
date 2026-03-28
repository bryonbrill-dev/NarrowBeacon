# NarrowBeacon

Yes — Terraform is a strong way to keep deployments repeatable across AWS and Azure from a single workflow.

This repository now includes a starter app and a multi-cloud Terraform baseline that can deploy a static site to:
- AWS S3 static website hosting
- Azure Storage static website hosting

## Project Layout

- `app/index.html`: initial application placeholder page
- `infra/terraform`: root Terraform stack and cloud selector
- `infra/terraform/modules/aws-static-site`: AWS static website module
- `infra/terraform/modules/azure-static-site`: Azure static website module

## Prerequisites

- Terraform `>= 1.5`
- AWS credentials configured (for AWS deploys)
- Azure credentials configured (for Azure deploys)

## Deploy

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

By default, `cloud_target = "both"` and both providers are deployed. You can set:
- `cloud_target = "aws"`
- `cloud_target = "azure"`
- `cloud_target = "both"`

## Next Development Steps

1. Replace `app/index.html` with your actual app build output.
2. Add CI/CD (GitHub Actions/Azure DevOps) to run `terraform fmt`, `validate`, `plan`, and gated `apply`.
3. Introduce environment folders (`dev`, `staging`, `prod`) with separate state backends.
4. Add DNS + TLS (AWS Route53/CloudFront, Azure DNS/Front Door) for production traffic.
