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

variable "application_key_name" {
  type        = string
  description = "Instance key pair name"
}

variable "application_subnet_id" {
  type        = string
  description = "Subnet id where application is deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where resources are deployed"
}

variable "application_user_data" {
  type        = string
  description = "APP user data"
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

variable "http_target_group_arn" {
  type        = string
  description = "Target group ARN of the ALB"
}