resource "aws_lambda_event_source_mapping" "sqs" {
  batch_size       = 10
  count            = var.SETTINGS["trigger"] == "sqs" ? 1 : 0
  event_source_arn = var.SETTINGS["event_source_arn"]
  function_name    = var.SETTINGS["lambda_arn"]
}

resource "aws_lambda_event_source_mapping" "kinesis" {
  count                              = var.SETTINGS["trigger"] == "kinesis" ? 1 : 0
  starting_position                  = var.SETTINGS["starting_position"]
  batch_size                         = var.SETTINGS["batch_size"]
  maximum_batching_window_in_seconds = var.SETTINGS["maximum_batching_window_in_seconds"]
  maximum_retry_attempts             = var.SETTINGS["maximum_retry_attempts"]
  event_source_arn                   = var.SETTINGS["event_source_arn"]
  function_name                      = var.SETTINGS["lambda_arn"]
  bisect_batch_on_function_error     = true
}