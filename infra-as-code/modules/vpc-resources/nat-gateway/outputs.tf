# Output section

output "id" {
  description = "Subnet id"
  value       = aws_nat_gateway.nat_gateway.id
}
