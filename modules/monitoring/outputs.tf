output "log_group_name" {
  description = "Name of the CloudWatch Log Group for application logs"
  value       = aws_cloudwatch_log_group.application.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_agent_role_arn" {
  description = "ARN of the CloudWatch agent IAM role"
  value       = aws_iam_role.cloudwatch_agent.arn
}