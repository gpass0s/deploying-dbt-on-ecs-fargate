output "arn" {
  description = "layer ARN"
  value       = aws_lambda_layer_version.python-layer.arn
}

output "id" {
  description = "layer ID"
  value       = aws_lambda_layer_version.python-layer.id
}