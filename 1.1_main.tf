provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name = "my-application-logs"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_filter" "error_filter" {
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  filter_pattern = "ERROR"
  log_filter_name = "error_filter"
  metric_transformation {
    metric_name = "ErrorCount"
    metric_namespace = "MyApplication"
    metric_value = count({ filter = @message LIKE "ERROR" })
  }
}

resource "aws_cloudwatch_metric_filter" "error_metric" {
  metric_name = aws_cloudwatch_log_filter.error_filter.metric_transformation[0].metric_name
  metric_namespace = aws_cloudwatch_log_filter.error_filter.metric_transformation[0].metric_namespace
  filter_pattern = "ERROR"
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name = "MyApplicationErrorAlarm"
  alarm_description = "Alarm triggered by high error count in logs"
  metric_name = aws_cloudwatch_metric_filter.error_metric.metric_name
  namespace = aws_cloudwatch_metric_filter.error_metric.metric_namespace
  statistic = "Sum"
  period = 60
  evaluation_periods = 2
  threshold = 100  # Triggers when total error count in 2 minutes exceeds 100
  alarm_actions = [
    "arn:aws:sns:us-east-1:123456789012:MyTopic"
  ]  # Send notification to an SNS topic
}

terraform {
  backend "s3" {
    bucket         = "state-files"
    key            = "path/to/your/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-file-locking"
  }
}
