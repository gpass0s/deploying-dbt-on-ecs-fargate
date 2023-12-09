#Creates a log group for lambda functions
resource "aws_cloudwatch_log_group" "log_for_lambda" {
  name              = "/aws/lambda/${var.OBSERVABILITY_SETTINGS["lambda_function_name"]}"
  retention_in_days = var.OBSERVABILITY_SETTINGS["log_retention_in_days"]
}

resource "aws_cloudwatch_metric_alarm" "alarm_error" {
  alarm_name          = "${var.OBSERVABILITY_SETTINGS["lambda_function_name"]}-alarmLambdaErros"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  alarm_description   = "Number of execution error is grater than expected"
  period              = var.ALARM_PERIOD
  statistic           = "Sum"
  unit                = "Count"
  datapoints_to_alarm = "1"
  treat_missing_data  = "missing"
  namespace           = "AWS/Lambda"
  threshold           = var.THRESHOLD_SETTINGS["alarm_error_threshold"]
  dimensions = {
    FunctionName = var.OBSERVABILITY_SETTINGS["lambda_function_name"]
  }
  alarm_actions             = var.ACTIONS_SETTINGS["alarm_actions"]
  ok_actions                = var.ACTIONS_SETTINGS["ok_actions"]
  insufficient_data_actions = var.ACTIONS_SETTINGS["insufficient_data_actions"]
  tags                      = var.AWS_TAGS
}

resource "aws_cloudwatch_metric_alarm" "throttles" {
  alarm_name          = "${var.OBSERVABILITY_SETTINGS["lambda_function_name"]}-alarmLambdaThrottles"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  alarm_description   = "Number of execution error is grater than expected"
  period              = var.ALARM_PERIOD
  statistic           = "Sum"
  unit                = "Count"
  datapoints_to_alarm = "1"
  treat_missing_data  = "missing"
  namespace           = "AWS/Lambda"
  threshold           = var.THRESHOLD_SETTINGS["alarm_error_threshold"]
  dimensions = {
    FunctionName = var.OBSERVABILITY_SETTINGS["lambda_function_name"]
  }
  alarm_actions             = var.ACTIONS_SETTINGS["alarm_actions"]
  ok_actions                = var.ACTIONS_SETTINGS["ok_actions"]
  insufficient_data_actions = var.ACTIONS_SETTINGS["insufficient_data_actions"]
  tags                      = var.AWS_TAGS
}