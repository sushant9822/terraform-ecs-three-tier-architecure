locals {
  region                          = var.regions[terraform.workspace]
  environment                     = terraform.workspace
  env_conf                        = lookup(var.environment, local.environment)
  kms_key_id                      = data.aws_kms_key.rds.arn
  performance_insights_kms_key_id = data.aws_kms_key.rds.arn
  cloudwatch_log_group_kms_key_id = data.aws_kms_key.rds.arn
  sg_config                       = lookup(var.environment, local.environment).sg_config

  tags = {
    Environment        = local.environment
    Use_case           = "rds"
    ProjectName        = "demo"
    Can_be_deleted     = true
    CreatedByTerraform = true
  }
}