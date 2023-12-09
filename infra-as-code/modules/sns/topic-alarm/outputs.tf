output "arn" {
  description = "ARN for the alerting sns"
  value       = aws_sns_topic.topic_alarm.arn
}
