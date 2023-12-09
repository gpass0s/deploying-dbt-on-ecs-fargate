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

variable "SECURITY_GROUP_DESCRIPTION" {
  description = "Security group description"
  default     = ""
}

variable "EGRESS_RULES" {
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = [{
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }]
}

variable "INGRESS_RULES" {
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    ipv6_cidr_blocks         = list(string)
    source_security_group_id = string
  }))
  default = [{
    description              = ""
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks              = []
    ipv6_cidr_blocks         = []
    source_security_group_id = ""
  }]
}
