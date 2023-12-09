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

variable "VPC_ID" {
  description = "ID of the VPC"
}

variable "SUBNET_ID" {
  description = "The Subnet ID of the subnet in which to place the gateway."
}

variable "ELASTIC_IP_ID" {
  description = "The Allocation ID of the Elastic IP address for the gateway."
}