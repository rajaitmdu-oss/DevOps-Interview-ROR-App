resource "aws_ecs_cluster" "rails" {
  
  name = "${local.name_prefix}-cluster"

  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${local.name_prefix}-cluster"
    }
  )

}