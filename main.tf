terraform {
  required_providers {
  aws = {
    source = "hashicorp/aws"
    version = "4.33.0"
  }
  }

# To maintain the state at Backend 
  backend "s3" {
  bucket = "terraform-romana-project"
  key    = "state"
  region = "ap-south-1"
  }
}

# Configure the AWS Provider 
provider "aws" {
    region = var.region
}

