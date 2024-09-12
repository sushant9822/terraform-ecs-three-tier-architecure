module "redis" {
  source  = "umotif-public/elasticache-redis/aws"
  version = "~> 3.5.0"

  name_prefix        = "${var.product}-${local.environment}"
  num_cache_clusters = local.env_conf.num_cache_clusters
  node_type          = local.env_conf.node_type

  engine_version           = local.env_conf.engine_version
  port                     = local.env_conf.port
  maintenance_window       = local.env_conf.maintenance_window
  snapshot_window          = local.env_conf.snapshot_window
  snapshot_retention_limit = local.env_conf.snapshot_retention_limit

  automatic_failover_enabled = local.env_conf.automatic_failover_enabled

  at_rest_encryption_enabled = local.env_conf.at_rest_encryption_enabled
  transit_encryption_enabled = local.env_conf.transit_encryption_enabled
  #auth_token                 = local.env_conf.auth_token

  apply_immediately = local.env_conf.apply_immediately
  family            = local.env_conf.family
  description       = "elasticache redis"

  subnet_ids = [data.terraform_remote_state.vpc.outputs.vpc_details.database_subnets[0], data.terraform_remote_state.vpc.outputs.vpc_details.database_subnets[1],data.terraform_remote_state.vpc.outputs.vpc_details.database_subnets[2]]
  #subnet_group_name = data.terraform_remote_state.vpc.outputs.vpc_details.database_subnet_group_name
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id

  ingress_cidr_blocks = local.env_conf.ingress_cidr_blocks

  parameter = local.env_conf.parameter
  log_delivery_configuration = local.env_conf.log_delivery_configuration

    

  tags = local.tags
}