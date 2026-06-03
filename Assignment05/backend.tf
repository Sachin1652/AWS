terraform {
  backend "s3" {
    bucket         = "sachin-tool-tfstate-bucket"
    key            = "env/prod/tool-docker/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
