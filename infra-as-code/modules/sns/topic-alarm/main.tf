locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
  EMAIL_ENV     = var.ENV == "prd" ? var.ENV : "test"
}

resource "aws_sns_topic" "topic_alarm" {
  name = local.RESOURCE_NAME
  tags = var.AWS_TAGS
}

resource "aws_sns_topic_subscription" "email-target" {
  count     = length(var.EMAIL_LIST)
  topic_arn = aws_sns_topic.topic_alarm.arn
  protocol  = "email"
  endpoint  = var.EMAIL_LIST[count.index]
}
