# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR_BLOCK
  instance_tenancy     = "default"
  enable_dns_hostnames = var.ENABLE_DNS_HOSTNAMES
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}