# Output section

output "id" {
  description = "Peering connection id"
  value       = aws_vpc_peering_connection.owner.id
}