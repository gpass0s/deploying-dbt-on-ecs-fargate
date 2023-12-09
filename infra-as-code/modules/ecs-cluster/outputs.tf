#Outputs

output "arn" {
  value       = aws_ecs_cluster.ecs_cluster.arn
  description = "ECS Cluster ARN"
}

output "cluster_name" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "ECS Cluster Name"
}