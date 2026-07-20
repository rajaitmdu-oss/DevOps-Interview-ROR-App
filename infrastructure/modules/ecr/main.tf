resource "aws_ecr_repository" "rails" {

  name = "${local.name_prefix}-rails"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rails-ecr"
    }
  )
}