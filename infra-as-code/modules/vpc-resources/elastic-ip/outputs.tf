# Output section

output "id" {
  description = "Elastic IP id"
  value       = aws_eip.eip.id
}