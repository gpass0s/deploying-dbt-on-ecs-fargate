output "arn" {
  value       = aws_cloudwatch_event_rule.rate[0].arn
  description = "Event rule ARN"
}