output "db_endpoint" {
  value = aws_db_instance.rails.address
}

output "db_instance_id" {
  value = aws_db_instance.rails.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rails.name
}

output "db_port" {
  value = aws_db_instance.rails.port
}

output "db_name" {
  value = aws_db_instance.rails.db_name
}