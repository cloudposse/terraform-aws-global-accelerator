variable "region" {
  type        = string
  description = "AWS region"
}

variable "alb_settings" {
  type        = any
  description = "Map containing variables to pass to the ALB module."
}

variable "ecs_web_app_settings" {
  type        = any
  description = "Map containing variables to pass to the ECS Web App module."
}

variable "vpc_settings" {
  type        = any
  description = "Map containing variables to pass to the VPC module."
}

variable "subnet_settings" {
  type        = any
  description = "Map containing variables to pass to the Dynamic Subnets module."
}

variable "s3_bucket_settings" {
  type        = any
  description = "Map containing variables to pass to the S3 Bucket module."
}
