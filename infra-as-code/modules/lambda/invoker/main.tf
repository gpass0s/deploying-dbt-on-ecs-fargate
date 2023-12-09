resource "aws_lambda_permission" "allow" {
  count         = var.INVOKER_TRIGGER_PARAMETERS["create_invoker"] == true ? 1 : 0 # create one or zero lambda permission
  action        = "lambda:InvokeFunction"
  statement_id  = var.INVOKER_TRIGGER_PARAMETERS["statement_id"]
  function_name = var.INVOKER_TRIGGER_PARAMETERS["lambda_arn"]
  principal     = var.INVOKER_TRIGGER_PARAMETERS["principal"]
  source_arn    = var.INVOKER_TRIGGER_PARAMETERS["source_arn"]
}