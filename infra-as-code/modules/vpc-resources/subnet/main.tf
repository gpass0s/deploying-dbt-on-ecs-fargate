# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_subnet" "subnet" {
  vpc_id            = var.VPC_ID
  cidr_block        = var.CIDR_BLOCK
  availability_zone = var.AVAILABILITY_ZONE

  map_public_ip_on_launch = var.MAP_PUBLIC_IP_ON_LAUNCH

  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}