variable "vpc_id" {
  type = string
}

variable "my_public_ip" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "default_vpc_cidr" {
  description = "CIDR block of Default VPC (for SSH via peering)"
  type        = string
}
