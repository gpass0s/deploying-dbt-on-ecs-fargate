# Output section

output "id" {
  description = "Subnet id"
  value       = aws_subnet.subnet.id
}

output "arn" {
  description = "Subnet arn"
  value       = aws_subnet.subnet.arn
}