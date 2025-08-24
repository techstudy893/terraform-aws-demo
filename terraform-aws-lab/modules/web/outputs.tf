output "public_ips" {
  description = "Public IPs of the web instances"
  value       = [for i in aws_instance.web : i.public_ip]
}

output "http_url" {
  description = "Convenience URL for the first instance"
  value       = length(aws_instance.web) > 0 ? "http://${aws_instance.web[0].public_ip}" : null
}