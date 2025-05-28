terraform {
  required_version = ">=0.15.0"
  backend "s3" {
    profile        = "USER PROFILE" # AWS CLI profile to use                
    region         = "eu-west-1"
    bucket         = "BUCKET NAME" # S3 bucket for storing state files
    key            = ".TFSTATE"    # Key in the S3 bucket for the state file
    encrypt        = true
    dynamodb_table = "DYNAMODB TABLE" # DynamoDB table for state locking
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.tags
}
