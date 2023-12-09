# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}


resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id            = var.VPC_ID
  service_name      = var.SERVICE_NAME
  vpc_endpoint_type = var.VPC_ENDPOINT_TYPE
  subnet_ids        = var.SUBNET_ID_LIST
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
  security_group_ids = var.SECURITY_GROUP_LIST

  private_dns_enabled = var.PRIVATE_DNS_ENABLED
}