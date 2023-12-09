variable "CLOUDWATCH_TRIGGER_PARAMETERS" {
  type = any
  default = {
    lambda_name = ""
    lambda_arn  = ""
    rate        = ""
    unity       = ""
  }
}
