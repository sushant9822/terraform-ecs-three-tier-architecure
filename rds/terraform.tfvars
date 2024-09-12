regions = {
  dev = "ap-south-1"
}
environment = {
  dev = {
    region                                 = "ap-south-1"
    profile                                = "demo"
    allocated_storage                      = 20
    storage_type                           = "gp2"
    storage_encrypted                      = true
    iam_database_authentication_enabled    = false
    engine                                 = "postgres"
    engine_version                         = "16.1"
    skip_final_snapshot                    = false
    copy_tags_to_snapshot                  = true
    instance_class                         = "db.t3.micro"
    db_name                                = "postgres_master"
    username                               = "postgres"
    port                                   = "5432"
    multi_az                               = false
    iops                                   = 0
    publicly_accessible                    = false
    monitoring_interval                    = 0
    create_monitoring_role                 = true
    allow_major_version_upgrade            = true
    auto_minor_version_upgrade             = true
    apply_immediately                      = true
    maintenance_window                     = "Mon:18:30-Mon:21:30"
    backup_retention_period                = null
    backup_window                          = "22:00-23:45"
    create_db_subnet_group                 = false
    create_db_parameter_group              = true
    family                                 = "postgres16"
    parameters                             = []
    create_db_option_group                 = true
    major_engine_version                   = 16
    options                                = {}
    enabled_cloudwatch_logs_exports        = []
    timeouts                               = {}
    option_group_timeouts                  = {}
    deletion_protection                    = false
    performance_insights_enabled           = false
    performance_insights_retention_period  = 7
    max_allocated_storage                  = 0
    ca_cert_identifier                     = null
    delete_automated_backups               = true
    create_cloudwatch_log_group            = true
    cloudwatch_log_group_retention_in_days = 7

    sg_config = {
      ingress_with_cidr_blocks = [
        {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = "10.40.0.0/16"
        }
      ]
    }
  }            
}

