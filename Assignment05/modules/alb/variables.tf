variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "target_instance_ids" {
  type = list(string)
}

variable "alb_name" {
  type = string
}

variable "tg_80_name" {
  type = string
}

variable "tg_8080_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
