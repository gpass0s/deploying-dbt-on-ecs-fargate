variable "RESOURCE_NAME" {}

variable "ECS_TASK_DEFINITIONS_ARN" {
  type = list(string)
}

variable "SECRET_MANAGER_ARN" {
  type = string
}

variable "ROLES_TO_ASSUME_ARN" {
  type = list(string)
}



