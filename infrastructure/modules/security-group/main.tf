resource "aws_security_group" "alb" {

  name        = "${local.name_prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

resource "aws_security_group" "ecs" {

  name        = "${local.name_prefix}-ecs-sg"
  description = "ECS Tasks"
  vpc_id = var.vpc_id

  ingress {

    description = "Rails"

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecs-sg"
    }
  )
}

resource "aws_security_group" "rds" {

  name        = "${local.name_prefix}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {

    description = "PostgreSQL"

    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )
}