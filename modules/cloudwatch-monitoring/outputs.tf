output "alarm_arns" {
  description = "CloudWatch alarm ARNs keyed by configured alarm name."
  value       = { for name, alarm in aws_cloudwatch_metric_alarm.this : name => alarm.arn }
}

output "alarm_names" {
  description = "CloudWatch alarm names."
  value       = keys(aws_cloudwatch_metric_alarm.this)
}
