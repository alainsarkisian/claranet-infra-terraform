terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "claranet-terraform"
    key    = "tf-state"
  }
}