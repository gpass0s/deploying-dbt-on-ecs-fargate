# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_internet_gateway" "gw" {
  vpc_id = var.VPC_ID
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}