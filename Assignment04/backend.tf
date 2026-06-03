terraform {
  backend "s3" {
    bucket         = "sachin-tool-tfstate-bucket" 
    key            = "env/static-test/tool-docker/terraform.tfstate" 
    region         = "ap-south-1"                
    encrypt        = true 
  }
}