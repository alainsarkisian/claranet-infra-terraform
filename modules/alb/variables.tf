variable "application_name" {
  type        = string
  description = "Name of the application to deploy"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where resources are deployed"
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

variable "application_port" {
  type        = string
  description = "Define the port of the application"
  default     = "3000"
}