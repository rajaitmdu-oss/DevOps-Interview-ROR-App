resource "aws_ecs_service" "rails" {

  name            = "${local.name_prefix}-service"
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn

  desired_count = 2

  launch_type = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {

    subnets = var.private_app_subnet_ids

    security_groups = [var.ecs_security_group_id]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = var.target_group_arn

    container_name = "rails"

    container_port = 3000
  }

  depends_on = [
    var.target_group_arn
  ]

  tags = local.common_tags
}