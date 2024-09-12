regions = {
  dev = "ap-south-1"
}
environment = {
  dev = {
    region                  = "ap-south-1"
    profile                 = "demo"
    appautoscaling_role_arn = ""
    cloud_service_cd       = "demo-cloud.json"
    capacity_provider_strategy = [
      {
        base              = 0
        capacity_provider = "FARGATE_SPOT"
        weight            = 1
      }
    ]

  }
}
