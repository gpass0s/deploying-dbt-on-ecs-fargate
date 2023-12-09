variable "PROJECT_NAME" {}
variable "ENV" {}
variable "RESOURCE_SUFFIX" {}
variable "AWS_TAGS" {
  type = map(string)
}

variable "EMAIL_LIST" {
  type    = list(any)
  default = []
}


