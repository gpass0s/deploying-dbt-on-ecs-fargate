variable "INVOKER_TRIGGER_PARAMETERS" {
  type = any
  default = {
    "create_invoker" = false
    "lambda_arn"     = ""
    "statement_id"   = ""
    "principal"      = ""
    "source_arn"     = ""
  }
}