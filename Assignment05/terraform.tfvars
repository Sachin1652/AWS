aws_region   = "ap-south-1"
project_name = "Tool"
environment  = "prod-docker"

vpc_cidr = "10.0.0.0/23"
public_subnets  = ["10.0.0.0/26", "10.0.0.64/26"]
private_subnets = ["10.0.0.128/25", "10.0.1.0/25"]

my_public_ip = "157.49.185.28/32"

ubuntu_ami_id  = "ami-0f5ee92e2d63afc18"
instance_type1 = "t3.micro"
key_name       = "awskey"

alb_name     = "application-alb"
tg_80_name   = "application-tg-80"
tg_8080_name = "application-tg-8080"

domain_name     = "sachinwork.in"
www_record_name = "www"
