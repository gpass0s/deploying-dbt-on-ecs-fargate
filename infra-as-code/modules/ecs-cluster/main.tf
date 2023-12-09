# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.RESOURCE_NAME
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}