variable "ssm_prefix" {
  type        = string
  description = "Prefix of each ssm parameter"
}

variable "db_ami_id" {
  type        = string
  description = "AMI of the DB instance"
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

variable "db_asg_min_size" {
  type        = string
  description = "Minimum number of instance for ASG"
}

variable "db_asg_max_size" {
  type        = string
  description = "Maximum number of instance for ASG"
}

variable "db_asg_desired_capacity" {
  type        = string
  description = "Desired number of instance for ASG"
}

variable "db_subnet_cidr_block" {
  type        = string
  description = "Subnet CIDR for Database"
}

variable "database_host" {
  type        = string
  description = "Define the host the of database"
}

variable "application_name" {
  type        = string
  description = "Name of the application to deploy"
}
