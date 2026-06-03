output "private_instance_ips" {
  description = "IPs of App Servers in Private Subnet"
  value       = module.ec2.private_instance_ips
}

output "alb_dns_name" {
  description = "URL to access the application"
  value       = module.alb.alb_dns_name
}

output "route53_name_servers" {
  description = "Update these in your Domain Registrar"
  value       = module.route53.name_servers
}
