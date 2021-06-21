variable "region" {
  type        = string
  description = "AWS region"
}

variable "alb_listener_port" {
  type        = number
  description = "The port on which the ALB will be listening."
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "ecs_configuration" {
  type = object({
    container_name               = string
    container_image              = string
    container_port               = number
    container_memory             = number
    container_memory_reservation = number
    container_cpu                = number
    health_check_path            = string
    host_port                    = number
  })
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "failover_region" {
  type        = string
  description = "AWS region to deploy the failover endpoint"
}

variable "failover_availability_zones" {
  type        = list(string)
  description = "List of availability zones for the failover region"
}

variable "failover_vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block for the failover region"
}
