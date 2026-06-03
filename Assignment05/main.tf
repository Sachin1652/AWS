module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.tags
}

module "security_groups" {
  source           = "./modules/security-groups"
  vpc_id           = module.vpc.vpc_id
  my_public_ip     = var.my_public_ip
  tags             = local.tags
  default_vpc_cidr = data.aws_vpc.default.cidr_block
}

# IAM Role module yahan se delete kar diya hai

module "ec2" {
  source             = "./modules/ec2"
  private_subnet_ids = module.vpc.private_subnet_ids
  # public_subnet_id hata diya gaya hai kyunki bastion nahi hai

  ubuntu_ami_id  = var.ubuntu_ami_id
  instance_type1 = var.instance_type1
  key_name       = var.key_name

  app_sg_id      = module.security_groups.app_sg_id
  # bastion_sg_id aur iam_role_name hata diye gaye hain

  tags = local.tags
}

module "alb" {
  source = "./modules/alb"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.security_groups.alb_sg_id
  target_instance_ids = module.ec2.app_instance_ids

  alb_name     = var.alb_name
  tg_80_name   = var.tg_80_name
  tg_8080_name = var.tg_8080_name

  tags = local.tags
}

module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name
  record_name = var.www_record_name

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

################################
# Data Sources
################################
data "aws_vpc" "default" {
  default = true
}
data "aws_route_tables" "default" {
  vpc_id = data.aws_vpc.default.id
}

################################
# VPC Peering
################################
module "vpc_peering" {
  source = "./modules/vpc-peering"

  requester_vpc_id          = module.vpc.vpc_id
  requester_route_table_ids = module.vpc.private_route_table_ids
  requester_cidr            = var.vpc_cidr

  accepter_vpc_id           = data.aws_vpc.default.id
  accepter_route_table_ids  = data.aws_route_tables.default.ids
  accepter_cidr             = data.aws_vpc.default.cidr_block

  tags = local.tags
}
