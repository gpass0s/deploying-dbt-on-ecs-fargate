output "arn" {
  description = "ARN from topic"
  value       = aws_sns_topic.topic.arn
}