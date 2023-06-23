resource "aws_sns_topic" "cpu_peak_topic" {
  name = "cloud-phoenix-kata-app-autoscaling-group-cpu-peak-topic"
}

resource "aws_sns_topic_subscription" "app_email_subscription" {
  topic_arn = aws_sns_topic.cpu_peak_topic.arn
  protocol  = "email"
  endpoint  = var.email
}