output "arn" {
  description = ""
  value       = aws_ecr_repository.images.arn
}

output "repository_url" {
  description = ""
  value       = aws_ecr_repository.images.repository_url
}