data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "infra-state-files"
    key     = "vpc.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }
  workspace = local.environment
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket  = "infra-state-files"
    key     = "alb.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }
  workspace = local.environment
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket  = "infra-state-files"
    key     = "ecr.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }
  workspace = local.environment
}
data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket  = "infra-state-files"
    key     = "cluster.tfstate"
    region  = "ap-south-1"
    profile = "demo"
  }
  workspace = local.environment
}

