resource "aws_db_subnet_group" "rails" {

  name = "${local.name_prefix}-db-subnet-group"

  subnet_ids = var.private_db_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-subnet-group"
    }
  )
}

resource "aws_db_instance" "rails" {

  identifier = "${local.name_prefix}-postgres"

  engine         = "postgres"
  engine_version = "13.3"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 5432

  publicly_accessible = false

  multi_az = false

  db_subnet_group_name = aws_db_subnet_group.rails.name

  vpc_security_group_ids = [
    var.rds_security_group_id
  ]

  skip_final_snapshot = true

  deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-postgres"
    }
  )
}