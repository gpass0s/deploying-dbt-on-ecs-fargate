variable "OBSERVABILITY_SETTINGS" {
  type = map(string)
}


variable "THRESHOLD_SETTINGS" {
  type = map(string)
  default = {
    alarm_error_threshold       = "1"
    alarm_invocations_threshold = "0"
  }
}

variable "ACTIONS_SETTINGS" {
  type = map(list(string))

  default = {
    alarm_actions             = []
    ok_actions                = []
    insufficient_data_actions = []
  }
}

variable "AWS_TAGS" {}

variable "ALARM_PERIOD" {
  type    = string
  default = "600"
}
