terraform {
  backend "s3" {
    bucket  = "infra-state-files"
    key     = "cloudfront.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = local.env_conf.profile
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  profile = local.env_conf.profile
}