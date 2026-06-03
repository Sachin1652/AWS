# Global
variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }

# VPC
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }

# Security
variable "my_public_ip" { type = string }

# EC2
variable "ubuntu_ami_id" { type = string }
variable "instance_type1" { type = string } # App instances ke liye (m7i-flex)
variable "key_name" { type = string }

# ALB
variable "alb_name" { type = string }
variable "tg_80_name" { type = string }
variable "tg_8080_name" { type = string }

# Route53
variable "domain_name" { type = string }
variable "www_record_name" { type = string }
