output "web_public_ips" { value = module.web.public_ips }
output "web_url" { value = module.web.http_url }
output "vpc_id" { value = module.vpc.vpc_id }
output "website_endpoint" { value = try(module.s3site.website_endpoint, null) }
