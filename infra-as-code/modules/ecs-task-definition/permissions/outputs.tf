output "ecs-task-execution-service-role-arn" {
  value       = aws_iam_role.iam_ecs_task_execution_service_role.arn
  description = "ARN for ECS Task Execution"
}

output "dbt-fargate-task-role-arn" {
  value       = aws_iam_role.dbt-fargate-task-role.arn
  description = "ARN for dbt-specific-fargate-task-role"
}