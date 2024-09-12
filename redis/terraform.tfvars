regions = {
  dev = "ap-south-1"
}
environment = {
  dev = {
    region             = "ap-south-1"
    profile            = "demo"
    num_cache_clusters = 1
    node_type          = "cache.t2.micro"

    engine_version           = "7.1"
    port                     = "6379"
    maintenance_window       = "mon:03:00-mon:04:00"
    snapshot_window          = "04:00-06:00"
    snapshot_retention_limit = null

    automatic_failover_enabled = "true"

    at_rest_encryption_enabled = "true"
    transit_encryption_enabled = "true"
    #auth_token                 = "1234567890asdfghjkl"

    apply_immediately = true
    family            = "redis7"

    ingress_cidr_blocks = ["0.0.0.0/0"]

    parameter = [
      {
        name  = "repl-backlog-size"
        value = "16384"
      }
    ]
    log_delivery_configuration = [
    {
      destination_type = "cloudwatch-logs"
      destination      = "demo-redis"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]

  }


}

