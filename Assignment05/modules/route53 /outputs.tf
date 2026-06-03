output "hosted_zone_id" {
  value = data.aws_route53_zone.this.zone_id
}
output "name_servers" {
  description = "Name servers of the existing hosted zone"
  value       = data.aws_route53_zone.this.name_servers
}
