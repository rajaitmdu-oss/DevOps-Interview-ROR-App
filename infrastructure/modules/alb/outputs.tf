output "alb_dns_name" {
  value = aws_lb.rails.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.rails.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "dns_name" {
  value = aws_lb.rails.dns_name
}