variable "ssm_prefix" {
  type        = string
  description = "Prefix of each ssm parameter"
}

variable "ami_id" {
  type        = string
  description = "AMI of the App instance"
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

variable "application_name" {
  type        = string
  description = "Name of the application to deploy"
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

variable "alb_arn" {
  type        = string
  description = "ALB ARN"
}

variable "app_subnet_cidr_block" {
  type        = string
  description = "Subnet CIDR for Application"
}

variable "application_subnet_ids" {
  type        = list(string)
  description = "Subnets ids for the autoscaling group"
}

variable "scaling_threshold" {
  type        = string
  description = "Number of req/min from which we need to scale out"
  default     = "100"
}

variable "email" {
  type        = string
  description = "Email where to subscripbe topic on which notifications will be sent"
}