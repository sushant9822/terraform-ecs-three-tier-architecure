terraform {
  backend "s3" {
    bucket = "infra-state-files"
    key    = "openvpn.tfstate"
    region = "ap-south-1"
    profile = "demo"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21"
    }
  }
}

provider "aws" {
  region              = local.region
  profile             = local.env_conf.profile
}