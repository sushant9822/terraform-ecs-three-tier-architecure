terraform {
  backend "s3" {
    bucket  = "infra-state-files"
    key     = "rds.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = local.env_conf.profile
}