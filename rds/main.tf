module "rds" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "6.7.0"
  identifier                          = "${var.product}-${local.environment}-rds"
  allocated_storage                   = local.env_conf.allocated_storage
  storage_type                        = local.env_conf.storage_type
  storage_encrypted                   = local.env_conf.storage_encrypted
  kms_key_id                          = local.kms_key_id
  iam_database_authentication_enabled = local.env_conf.iam_database_authentication_enabled
  engine                              = local.env_conf.engine
  engine_version                      = local.env_conf.engine_version
  skip_final_snapshot                 = local.env_conf.skip_final_snapshot
  copy_tags_to_snapshot               = local.env_conf.copy_tags_to_snapshot
  instance_class                      = local.env_conf.instance_class
  db_name                             = local.env_conf.db_name
  username                            = local.env_conf.username
  port                                = local.env_conf.port
  vpc_security_group_ids              = [module.security-group.security_group_id]
  availability_zone                   = "${local.env_conf.region}a"
  multi_az                            = local.env_conf.multi_az
  iops                                = local.env_conf.iops
  publicly_accessible                 = local.env_conf.publicly_accessible
  monitoring_interval                 = local.env_conf.monitoring_interval
  monitoring_role_name                = "${local.environment}-${var.product}-rds-monitoring-role"
  create_monitoring_role              = local.env_conf.create_monitoring_role
  allow_major_version_upgrade         = local.env_conf.allow_major_version_upgrade
  auto_minor_version_upgrade          = local.env_conf.auto_minor_version_upgrade
  apply_immediately                   = local.env_conf.apply_immediately
  maintenance_window                  = local.env_conf.maintenance_window
  backup_retention_period             = local.env_conf.backup_retention_period
  backup_window                       = local.env_conf.backup_window
  create_db_subnet_group              = local.env_conf.create_db_subnet_group
  db_subnet_group_name                = data.terraform_remote_state.vpc.outputs.vpc_details.database_subnet_group_name
  #subnet_ids                             = [data.terraform_remote_state.vpc.outputs.vpc_details.database_subnets[0],data.terraform_remote_state.vpc.outputs.vpc_details.database_subnets[1]]
  create_db_parameter_group              = local.env_conf.create_db_parameter_group
  parameter_group_name                   = null # "${local.identifier}-parameter-group"
  family                                 = local.env_conf.family
  parameters                             = local.env_conf.parameters
  create_db_option_group                 = local.env_conf.create_db_option_group
  option_group_name                      = null # "${local.identifier}-options-group"
  major_engine_version                   = local.env_conf.major_engine_version
  options                                = local.env_conf.options
  enabled_cloudwatch_logs_exports        = local.env_conf.enabled_cloudwatch_logs_exports
  timeouts                               = local.env_conf.timeouts
  option_group_timeouts                  = local.env_conf.option_group_timeouts
  deletion_protection                    = local.env_conf.deletion_protection
  performance_insights_enabled           = local.env_conf.performance_insights_enabled
  performance_insights_retention_period  = local.env_conf.performance_insights_retention_period
  performance_insights_kms_key_id        = local.performance_insights_kms_key_id
  max_allocated_storage                  = local.env_conf.max_allocated_storage
  ca_cert_identifier                     = local.env_conf.ca_cert_identifier
  delete_automated_backups               = local.env_conf.delete_automated_backups
  create_cloudwatch_log_group            = local.env_conf.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = local.env_conf.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = local.cloudwatch_log_group_kms_key_id
  tags                                   = local.tags

}

module "security-group" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "4.9.0"
  name                     = "${local.environment}-${var.product}-rds-sg"
  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  ingress_with_cidr_blocks = local.sg_config.ingress_with_cidr_blocks
  tags                     = local.tags

}

