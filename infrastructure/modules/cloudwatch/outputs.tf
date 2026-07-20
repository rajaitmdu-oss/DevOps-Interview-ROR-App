output "log_group_name" {
  value = aws_cloudwatch_log_group.rails.name
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.rails.arn
}