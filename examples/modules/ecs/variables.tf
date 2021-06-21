variable "region" {
  type        = string
  description = "AWS region"
}

variable "alb_listener_port" {
  type        = number
  description = "The port on which the ALB will be listening."
}

variable "container_configuration" {
  type = object({
    name               = string
    image              = string
    port               = number
    memory             = number
    memory_reservation = number
    cpu                = number
  })
}

variable "health_check_path" {
  type        = string
  description = "The endpoint path on which the ALB will be performing health checks for its targets."
}

variable "host_port" {
  type        = number
  description = "The port on which the ECS host will be listening."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where resources will be provisioned."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR Block of the VPC."
}

variable "vpc_private_subnet_ids" {
  type        = list(string)
  description = "List of IDs of the Private Subnets in the VPC."
}

variable "vpc_public_subnet_ids" {
  type        = list(string)
  description = "List of IDs of the Public Subnets in the VPC."
}
