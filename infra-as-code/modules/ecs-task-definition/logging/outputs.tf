output "cloudwatch_log_group_name" {
  description = "Log group for ECS cluster"
  value       = aws_cloudwatch_log_group.log_for_ecs_cluster.name
}