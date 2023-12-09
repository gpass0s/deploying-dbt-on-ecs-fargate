resource "aws_cloudwatch_event_rule" "rate" {
  count               = var.CLOUDWATCH_TRIGGER_PARAMETERS["rate"] == "" ? 0 : 1
  name                = var.CLOUDWATCH_TRIGGER_PARAMETERS["lambda_name"]
  description         = "rate at which function should be executed"
  schedule_expression = "rate(${var.CLOUDWATCH_TRIGGER_PARAMETERS["rate"]} ${var.CLOUDWATCH_TRIGGER_PARAMETERS["unity"]})"
}

resource "aws_cloudwatch_event_target" "scheduling_rate_lambda_target" {
  count = var.CLOUDWATCH_TRIGGER_PARAMETERS["rate"] == "" ? 0 : 1
  arn   = var.CLOUDWATCH_TRIGGER_PARAMETERS["lambda_arn"]
  rule  = aws_cloudwatch_event_rule.rate[0].name
}