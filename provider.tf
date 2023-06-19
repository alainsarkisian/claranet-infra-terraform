provider "aws" {
  profile = "claranet"
  region  = var.aws_region

  default_tags {
    tags = {
      Application = var.application_name
      Region      = var.aws_region
      Iac         = "true"
    }
  }
}