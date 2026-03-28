variable "project_name" {
  description = "Project name prefix used in resource naming."
  type        = string
  default     = "narrowbeacon"
}

variable "cloud_target" {
  description = "Where to deploy: aws, azure, or both."
  type        = string
  default     = "both"

  validation {
    condition     = contains(["aws", "azure", "both"], var.cloud_target)
    error_message = "cloud_target must be one of: aws, azure, both."
  }
}

variable "aws_region" {
  description = "AWS region for AWS resources."
  type        = string
  default     = "us-east-1"
}

variable "azure_location" {
  description = "Azure location for Azure resources."
  type        = string
  default     = "eastus"
}

variable "index_html" {
  description = "Content for the default index.html page uploaded during deployment."
  type        = string
  default     = <<-HTML
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>NarrowBeacon</title>
      </head>
      <body>
        <main>
          <h1>NarrowBeacon</h1>
          <p>Deployed with Terraform to multi-cloud infrastructure.</p>
        </main>
      </body>
    </html>
  HTML
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default = {
    managed-by = "terraform"
    project    = "narrowbeacon"
  }
}
