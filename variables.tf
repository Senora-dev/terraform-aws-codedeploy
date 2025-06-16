variable "name" {
  description = "The name of the application"
  type        = string
}

variable "app_name" {
  description = "The name of the application (alias for name)"
  type        = string
  default     = null
}

locals {
  app_name = coalesce(var.app_name, var.name)
}

variable "s3_bucket" {
  description = "The S3 bucket for CodeDeploy artifacts"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "alb_listener_arn" {
  description = "The ARN of the load balancer listener for production traffic"
  type        = string
}

variable "alb_test_listener_arn" {
  description = "The ARN of the load balancer listener for test traffic"
  type        = string
}

variable "alb_tg_blue_name" {
  description = "The name of the blue target group"
  type        = string
}

variable "alb_tg_green_name" {
  description = "The name of the green target group"
  type        = string
}

variable "ecs_iam_roles_arns" {
  description = "List of IAM role ARNs for ECS tasks"
  type        = list(string)
}

variable "termination_wait_time_in_minutes" {
  description = "The number of minutes to wait after a successful blue/green deployment before terminating the blue environment"
  type        = number
  default     = 120
}