variable "private_subnet_ids" {
  type = list(string)
}

variable "ubuntu_ami_id" {
  type = string
}

variable "instance_type1" {
  type = string
}

variable "key_name" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
