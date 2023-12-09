# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "eip" {
  vpc = true
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}