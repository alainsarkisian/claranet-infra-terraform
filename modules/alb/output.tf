output "http_target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

output "alb_arn" {
  value = aws_lb.alb.arn
}