regions = {
  dev = "ap-south-1"
}
environment = {
  dev = {
    region = "ap-south-1"
    profile = "demo"
    default_capacity_provider_strategy = [
      {
        base              = 0
        capacity_provider = "FARGATE_SPOT"
        weight            = 1
      }
    ]
  }
}