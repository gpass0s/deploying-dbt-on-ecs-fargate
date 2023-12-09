# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}


resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = var.VPC_ID
  service_name      = "com.amazonaws.${var.AWS_REGION}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.SUBNET_ID_LIST
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
  security_group_ids = var.SECURITY_GROUP_LIST

  private_dns_enabled = true
}