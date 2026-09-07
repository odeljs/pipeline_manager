terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "hashi-terraform-states"
    key    = "pipeline_manager/IaC/tf-plan/module_updates/terraform.tfstate"
    region = "us-east-1"
  }
}

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