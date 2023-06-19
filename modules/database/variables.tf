variable "ssm_prefix" {
  type        = string
  description = "Prefix of each ssm parameter"
}

variable "ami_id" {
  type        = string
  description = "AMI of the instance"
  default     = "ami-04f86108c32876f88"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t3.small"
}

variable "database_key_name" {
  type        = string
  description = "Instance key pair name"
}

variable "database_subnet_id" {
  type        = string
  description = "Subnet id where Database is deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where resources are deployed"
}

variable "database_user_data" {
  type        = string
  description = "DB user data"
}

variable "app_security_group_id" {
  description = "ID of the app security group"
}
