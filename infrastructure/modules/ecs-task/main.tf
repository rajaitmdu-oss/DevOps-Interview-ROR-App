resource "aws_ecs_task_definition" "rails" {

  family = "${local.name_prefix}-task"

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu    = "512"
  memory = "1024"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "rails"
      image     = "${var.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "RDS_DB_NAME"
          value = var.db_name
        },
        {
          name  = "RDS_USERNAME"
          value = var.db_username
        },
        {
          name  = "RDS_PASSWORD"
          value = var.db_password
        },
        {
          name  = "RDS_HOSTNAME"
          value = var.db_host
        },
        {
          name  = "RDS_PORT"
          value = "5432"
        },
        {
          name  = "S3_BUCKET_NAME"
          value = var.bucket_name
        },
        {
          name  = "S3_REGION_NAME"
          value = var.aws_region
        },
        {
          name  = "LB_ENDPOINT"
          value = var.lb_endpoint
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.common_tags
}

