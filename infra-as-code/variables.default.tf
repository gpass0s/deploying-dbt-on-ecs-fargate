variable "AWS_TAGS" {
  type = map(string)
  default = {
    "Project Name"        = "gpassos-jaffle-shop"
    "Project Description" = "A demo data pipeline designed to exemplify the deployment process of dbt on ECS Fargate"
    "Sector"              = "Data Engineer"
    "Company"             = "Passos Data Engineering"
    "Cost center"         = "0001"
  }
}

variable "VPC_CIDR_BLOCKS" {
  type = map(string)
  default = {
    dev = "192.168.0.0/16"
    stg = "192.168.0.0/16"
    prd = "192.168.0.0/16"
  }
}

variable "PRIVATE_SUBNET_1A_CIDR_BLOCKS" {
  type = map(string)
  default = {
    dev = "192.168.0.0/24"
    qa  = "11.0.0.0/24"
    stg = "192.168.0.0/24"
    prd = "192.168.0.0/24"
  }
}

variable "PUBLIC_SUBNET_1A_CIDR_BLOCKS" {
  type = map(string)
  default = {
    dev = "192.168.3.0/24"
    qa  = "11.0.3.0/24"
    stg = "192.168.3.0/24"
    prd = "192.168.3.0/24"
  }
}