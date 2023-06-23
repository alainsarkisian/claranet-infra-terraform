resource "aws_cloudwatch_metric_alarm" "app_scale_out_metric" {
  alarm_name          = "${var.application_name}-app-autoscaling-group-scale-out-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = var.scaling_threshold

  alarm_description = "Scale out the autoscaling group if request count exceeds 100 per minute"
  alarm_actions     = [aws_autoscaling_policy.app_asg_policy.arn]

  dimensions = {
    LoadBalancer = var.alb_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_peak_alarm" {
  alarm_name          = "cloud-phoenix-kata-app-autoscaling-group-cpu-peak-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "CPU peak alarm for the Application Auto Scaling Group"
  alarm_actions       = [aws_autoscaling_notification.app_asg_notification.topic_arn]
}