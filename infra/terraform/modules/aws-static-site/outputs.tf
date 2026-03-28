output "bucket_name" {
  description = "S3 bucket name."
  value       = aws_s3_bucket.this.bucket
}

output "website_url" {
  description = "S3 website endpoint URL."
  value       = format("http://%s", aws_s3_bucket_website_configuration.this.website_endpoint)
}
