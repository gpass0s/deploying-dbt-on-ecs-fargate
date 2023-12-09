data "aws_region" "aws_account_region" {}
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
  AWS_REGION    = data.aws_region.aws_account_region.name
}

module "logging" {
  source = "./logging"
  LOGGING_SETTINGS = {
    "ecs_cluster_name"      = local.RESOURCE_NAME
    "log_retention_in_days" = var.LOG_RETENTION_IN_DAYS
  }
}

module "permissions" {
  source          = "./permissions"
  RESOURCE_PREFIX = local.RESOURCE_NAME
  AWS_TAGS        = var.AWS_TAGS
  ENV             = var.ENV
  ECS_CLUSTER_ARN = var.DBT_ECS_CLUSTER_ARN
  ECS_TASK_ARN    = aws_ecs_task_definition.task_definition.arn
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${local.RESOURCE_NAME}-for-dbt"
  execution_role_arn       = module.permissions.ecs-task-execution-service-role-arn
  task_role_arn            = module.permissions.dbt-fargate-task-role-arn
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags                     = var.AWS_TAGS
  container_definitions    = <<EOF
[
  {
    "name": "${local.RESOURCE_NAME}-container",
    "image": "${var.ECR_REPOSITORY_URL}:${var.ECR_IMAGE_NAME}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${local.AWS_REGION}",
        "awslogs-group": "/aws/ecs/${var.PROJECT_NAME}-${var.ENV}-ecs-cluster",
        "awslogs-stream-prefix": "ecs/${var.PROJECT_NAME}-${var.ENV}"
      }
    }
  }
]
EOF
}
