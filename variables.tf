variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "Name of the AWS region where to deply the infrastructure"
}

variable "application_name" {
  type        = string
  description = "Name of the application to deploy"
}

variable "ssm_prefix" {
  type        = string
  description = "Prefix for the SSM parameters"
  default     = "claranet"
}

variable "password_lenght" {
  type        = number
  description = "Define the password length of the generated password for MongoDB"
  default     = 16
}

variable "password_allows_special" {
  type        = bool
  description = "Define if the password can contain some special characters"
  default     = false
}

variable "password_override_special" {
  type        = string
  description = "Define the special characters that are allowed for the password generation"
  default     = "@/"
}

variable "database_username" {
  type        = string
  description = "Define the username the of database"
}

variable "database_host" {
  type        = string
  description = "Define the host the of database"
}

variable "database_port" {
  type        = string
  description = "Define the port the of database"
  default     = "27017"
}

variable "database_name" {
  type        = string
  description = "Define the name the of database"
  default     = "claranet"
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
  description = "Database instance key pair name"
}

variable "database_subnet_id" {
  type        = string
  description = "Subnet id where Database is deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where resources are deployed"
}

variable "application_key_name" {
  type        = string
  description = "Application instance key pair name"
}

variable "application_subnet_id" {
  type        = string
  description = "Subnet id where application is deployed"
}

variable "private_zone_id" {
  type        = string
  description = "Private zone ID where records must be defined"
}

variable "alb_dns" {
  type        = string
  description = "Name of the record DNS for the ALB"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the TLS certificate to use on ALB listener"
}

variable "alb_healthy_threshold" {
  type        = number
  description = "Healthy threshold for the health check"
  default     = 3
}

variable "alb_unhealthy_threshold" {
  type        = number
  description = "Unhealthy threshold for the health check"
  default     = 3
}

variable "alb_hc_interval" {
  type        = number
  description = "Health check interval"
  default     = 30
}

variable "app_asg_min_size" {
  type        = string
  description = "Minimum number of instance for ASG"
}

variable "app_asg_max_size" {
  type        = string
  description = "Maximum number of instance for ASG"
}

variable "app_asg_desired_capacity" {
  type        = string
  description = "Desired number of instance for ASG"
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
# 0 1 * * 0 /path/to/backup_script.sh
