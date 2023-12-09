# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_vpc_peering_connection" "owner" {
  peer_owner_id = var.PEER_OWNER_ID
  peer_vpc_id   = var.PEER_VPC_ID
  vpc_id        = var.VPC_ID
  auto_accept   = false
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}
