locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
}

resource "aws_sns_topic" "topic" {
  name = local.RESOURCE_NAME
}

module "security" {
  source    = "./security"
  TOPIC_ARN = aws_sns_topic.topic.arn
}
