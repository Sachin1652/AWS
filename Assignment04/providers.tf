terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Agar aap state file S3 mein rakhna chahte hain toh ise uncomment karein
  # backend "s3" {
  #   bucket         = "sachin-terraform-state"
  #   key            = "tool-static/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "terraform-lock"
  # }
}

provider "aws" {
  region = var.aws_region 
}