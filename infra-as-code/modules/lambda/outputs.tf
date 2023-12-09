output "arn" {
  value       = aws_lambda_function.lambda.arn
  description = "ARN from AWS Lambda"
}

output "invoke_arn" {
  value       = aws_lambda_function.lambda.invoke_arn
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
}

output "function_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "function_name"
}

output "role-name" {
  value       = module.permissions.role-name
  description = "Name from AWS Lambda Role"
}
