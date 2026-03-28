output "aws_bucket_name" {
  description = "AWS S3 bucket name for static site hosting (null when not deployed)."
  value       = try(module.aws_static_site[0].bucket_name, null)
}

output "aws_website_url" {
  description = "AWS S3 website endpoint (null when not deployed)."
  value       = try(module.aws_static_site[0].website_url, null)
}

output "azure_storage_account" {
  description = "Azure Storage Account name for static site hosting (null when not deployed)."
  value       = try(module.azure_static_site[0].storage_account_name, null)
}

output "azure_website_url" {
  description = "Azure static website endpoint (null when not deployed)."
  value       = try(module.azure_static_site[0].website_url, null)
}
