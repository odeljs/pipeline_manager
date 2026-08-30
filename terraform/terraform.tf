terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "hashi-terraform-states"
    key    = "pipeline_manager/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner       = "Cloud_Engineering"
      ManagedBy   = "Terraform"
      Source      = "pipeline_manager" 
    }
  }
}