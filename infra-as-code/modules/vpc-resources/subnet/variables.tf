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

variable "MAP_PUBLIC_IP_ON_LAUNCH" {
  description = "Toggle to assign public IP to instances in the subnet"
  type        = bool
  default     = false
}

variable "CIDR_BLOCK" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "AVAILABILITY_ZONE" {
  description = <<EOF
    Availability zones are isolated locations within an AWS region, providing fault
    tolerance and high availability for resources.
  EOF
  type        = string
  default     = "us-east-1a"
}