output "db_endpoint" {
  value = aws_db_instance.rails.address
}

output "db_port" {
  value = aws_db_instance.rails.port
}

output "db_name" {
  value = aws_db_instance.rails.db_name
}