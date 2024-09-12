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
data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}
