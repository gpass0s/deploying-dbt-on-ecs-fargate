# Locals section
locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

# Resources section

resource "aws_security_group" "security_group" {
  name        = local.RESOURCE_NAME
  description = var.SECURITY_GROUP_DESCRIPTION
  vpc_id      = var.VPC_ID

  lifecycle {
    create_before_destroy = true
  }

  dynamic "egress" {

    for_each = var.EGRESS_RULES

    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = var.INGRESS_RULES

    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = length(ingress.value.source_security_group_id) > 0 ? [ingress.value.source_security_group_id] : []
    }

  }
  tags = merge(var.AWS_TAGS, {
    Name = local.RESOURCE_NAME
  })
}