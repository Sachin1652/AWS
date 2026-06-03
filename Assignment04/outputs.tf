output "alb_dns" { value = aws_lb.main.dns_name }
output "vpc_id" { value = aws_vpc.this.id }
output "instance_private_ips" { value = aws_instance.app[*].private_ip }