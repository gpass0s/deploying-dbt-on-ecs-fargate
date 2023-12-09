# Output section

output "id" {
  description = "AWS VPC endpoint id"
  value       = aws_vpc_endpoint.ecr.id
}

output "network_interface_ids" {
  description = "AWS VPC endpoint interface ids"
  value       = aws_vpc_endpoint.ecr.network_interface_ids
}
