output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.site.id
}

output "website_endpoint" {
  description = "S3 static website endpoint (if configured)"
  value       = try(aws_s3_bucket_website_configuration.w.website_endpoint, null)
}
