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