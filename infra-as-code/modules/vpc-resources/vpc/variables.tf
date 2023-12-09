# Variables section

variable "PROJECT_NAME" {
  description = "The name of the project"
}

variable "ENV" {
  description = "The environment (e.g., dev, prod)"
}

variable "RESOURCE_SUFFIX" {
  description = "Suffix for the resource name"
}

variable "AWS_TAGS" {
  description = <<EOF
  Tags are key-value pairs that provide metadata and labeling to resources for better management.
EOF
  type        = map(string)
}

variable "VPC_CIDR_BLOCK" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ENABLE_DNS_HOSTNAMES" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = string
  default     = false
}