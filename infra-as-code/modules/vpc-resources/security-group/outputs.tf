# Output section


output "id" {
  description = "Security group id"
  value       = aws_security_group.security_group.id
}

output "arn" {
  description = "Security group arn"
  value       = aws_security_group.security_group.arn
}