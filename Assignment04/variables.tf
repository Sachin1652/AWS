variable "vpc_cidr" { default = "10.0.0.0/23" }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "ubuntu_ami_id" { type = string }
variable "instance_type1" { default = "t2.micro" }
variable "key_name" { type = string }
variable "domain_name" { type = string }
variable "default_vpc_id" { type = string }
variable "default_vpc_cidr" { type = string }
variable "tags" { type = map(string) }
variable "alb_name" { default = "main-alb" }
variable "tg_80_name" { default = "tg-80" }
variable "tg_8080_name" { default = "tg-8080" }
variable "aws_region" {
  type = string
}