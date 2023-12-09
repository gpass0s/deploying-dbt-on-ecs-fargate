# Variables section

variable "PROJECT_NAME" {
  description = "The name of the project"
}

variable "ENV" {
  description = "The environment (e.g., dev, prod)"
}

variable "VPC_ID" {
  description = "VPC ID for the VPC Endpoint"
}

variable "SUBNET_ID_LIST" {
  description = "List of subnets to attach to this VPC endpoint"
}

variable "SECURITY_GROUP_LIST" {
  description = "SG for the VPC endpoint"
}

variable "RESOURCE_SUFFIX" {
  description = "Suffix for the resource name"
}

variable "AWS_REGION" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "AWS_TAGS" {
  description = <<EOF
  Tags are key-value pairs that provide metadata and labeling to resources for better management.
EOF
  type        = map(string)
}