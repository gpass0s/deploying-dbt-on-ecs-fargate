# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = var.ELASTIC_IP_ID
  subnet_id     = var.SUBNET_ID

  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}
