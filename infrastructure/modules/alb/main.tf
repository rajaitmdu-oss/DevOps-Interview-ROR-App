resource "aws_lb" "rails" {

  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb"
    }
  )
}

resource "aws_lb_target_group" "rails" {

  name        = "${local.name_prefix}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    path = "/"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.rails.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.rails.arn
  }
}