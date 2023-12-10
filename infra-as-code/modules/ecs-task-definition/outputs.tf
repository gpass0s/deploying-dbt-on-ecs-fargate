
output "task-definition-arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

output "task-definition-container-name" {
  value = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}-container"
}

output "task-definition-role-arn" {
  value = module.permissions.ecs-task-execution-service-role-arn
}

output "dbt-fargate-task-role-arn" {
  value = module.permissions.dbt-fargate-task-role-arn
}
