output "private_instance_ips" {
  description = "Private IPs of application instances"
  value       = aws_instance.app[*].private_ip
}

output "app_instance_ids" {
  description = "Instance IDs of application EC2s"
  value       = aws_instance.app[*].id
}
