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


## Self-Hosted on Windows (No Terraform)

If you want to run this project on your own Windows machine without Terraform, the simplest approach is to host the static files with IIS.

### Option A: IIS Static Site (Recommended for Windows servers)

1. **Enable IIS**
   - Open **Turn Windows features on or off**
   - Enable **Internet Information Services** (and **World Wide Web Services**)

2. **Copy the app files**
   - Create a folder such as `C:\\inetpub\\narrowbeacon`
   - Copy `app/index.html` (and any other static assets) into that folder

3. **Create an IIS website**
   - Open **IIS Manager**
   - Right-click **Sites** -> **Add Website...**
   - Site name: `NarrowBeacon`
   - Physical path: `C:\\inetpub\\narrowbeacon`
   - Binding: choose port (for example `8080`)

4. **Allow firewall access (if needed)**
   - Open Windows Defender Firewall settings
   - Add an inbound rule for your chosen port (for example TCP `8080`)

5. **Browse to the site**
   - Local machine: `http://localhost:8080`
   - From another machine on your LAN: `http://<windows-host-ip>:8080`

### Option B: Quick Local Test Without IIS

If you only want a quick test server, from PowerShell:

```powershell
cd app
python -m http.server 8080
```

Then open `http://localhost:8080`.

## Next Development Steps

1. Replace `app/index.html` with your actual app build output.
2. Add CI/CD (GitHub Actions/Azure DevOps) to run `terraform fmt`, `validate`, `plan`, and gated `apply`.
3. Introduce environment folders (`dev`, `staging`, `prod`) with separate state backends.
4. Add DNS + TLS (AWS Route53/CloudFront, Azure DNS/Front Door) for production traffic.
