# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

resource "aws_route_table" "route_table" {
  vpc_id = var.VPC_ID

  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}
