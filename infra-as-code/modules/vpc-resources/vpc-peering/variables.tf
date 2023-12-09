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

variable "PEER_OWNER_ID" {
  description = "The AWS account ID of the owner of the peer VPC."
}

variable "PEER_VPC_ID" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection"
}

variable "VPC_ID" {
  description = "The ID of the requester VPC"
}