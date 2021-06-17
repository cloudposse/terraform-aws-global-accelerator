output "alb" {
  description = "Outputs from the alb module."
  value       = module.alb
}

output "ecs_web_app" {
  description = "Outputs from the ecs_web_app module."
  value       = module.ecs_web_app
  sensitive   = true
}

output "vpc" {
  description = "Outputs from the vpc module."
  value       = module.vpc
}

output "subnets" {
  description = "Outputs from the subnets module."
  value       = module.subnets
}

output "s3_bucket" {
  description = "Outputs from the s3_bucket module."
  value       = module.s3_bucket
  sensitive   = true
}
