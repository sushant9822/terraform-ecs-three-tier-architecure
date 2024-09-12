resource "aws_ecs_service" "demo-service" {
  name    = "${var.product}-${local.environment}-demo-service"
  cluster = data.terraform_remote_state.cluster.outputs.cluster_id
  task_definition                   = aws_ecs_task_definition.demo-service.arn
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 300
  dynamic "capacity_provider_strategy" { # forces replacement
    for_each = try(local.env_conf.capacity_provider_strategy, [])
    content {
      base              = capacity_provider_strategy.value.base
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }

  }

  deployment_controller {
    type = "ECS"
  }
  lifecycle {
    # create_before_destroy = true
    ignore_changes = [task_definition, desired_count]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = 0

  load_balancer {
    elb_name         = ""
    target_group_arn = data.terraform_remote_state.alb.outputs.alb_details.target_group_arns[0]
    container_name   = "demo-service"
    container_port   = 3333
  }
  network_configuration {
    #subnets         = ["${data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets[0]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets[1]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets[1]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets[2]}"]
    subnets         = ["${data.terraform_remote_state.vpc.outputs.vpc_details.private_subnets[0]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.private_subnets[1]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.private_subnets[1]}", "${data.terraform_remote_state.vpc.outputs.vpc_details.private_subnets[2]}"]
    security_groups = ["${module.security_group.security_group_id}"]
    assign_public_ip = true

  }
}

resource "aws_ecs_task_definition" "demo-service" {
  family                   = "${var.product}-${local.environment}-demo-service"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file(local.env_conf.demo_service_cd)
  cpu                      = 512
  execution_role_arn       = ""
  task_role_arn            = ""
  network_mode             = "awsvpc"
  memory                   = 1024
}



resource "aws_appautoscaling_target" "demo_ecs_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${data.terraform_remote_state.cluster.outputs.cluster_name}/${aws_ecs_service.demo-service.name}"
  role_arn           = local.env_conf.appautoscaling_role_arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  lifecycle {
    ignore_changes        = [role_arn, min_capacity, max_capacity]
  }
}

resource "aws_appautoscaling_policy" "demo_ecs_policy" {
  name               = "${local.environment}-${var.product}-demo-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.demo_ecs_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.demo_ecs_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.demo_ecs_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 120
    scale_out_cooldown = 120
  }
}


resource "aws_appautoscaling_policy" "demo_service_fargate_autoscaling_policy_mem_max" {
  name               = "${var.product}-${local.environment}-demo-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.demo_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.demo_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.demo_ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    customized_metric_specification {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      dimensions {
        name  = "ServiceName"
        value = aws_ecs_service.demo-service.name
      }
      dimensions {
        name  = "ClusterName"
        value = data.terraform_remote_state.cluster.outputs.cluster_name
      }
      statistic = "Maximum"
      unit      = "Percent"
    }
    target_value       = 80
    scale_in_cooldown  = 120
    scale_out_cooldown = 120
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.product}-${local.environment}-service-sg"
  description = "Security group for Service"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  tags        = local.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3030
      to_port     = 3030
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3333
      to_port     = 3333
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
