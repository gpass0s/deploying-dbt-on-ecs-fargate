resource "aws_sns_topic_subscription" "subscription" {
  topic_arn     = var.SETTINGS["topic_arn"]
  protocol      = var.SETTINGS["protocol"]
  endpoint      = var.SETTINGS["endpoint"]
  filter_policy = var.SETTINGS["filter_policy"]
}