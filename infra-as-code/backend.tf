terraform {
  backend "s3" {
    key     = "quext-data-analytics/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}