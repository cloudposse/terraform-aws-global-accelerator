output "alb_arn" {
  value       = module.alb.alb_arn
  description = "The ARN of the ALB dedicated to the ECS Service."
}

output "alb_name" {
  value       = module.alb.alb_name
  description = "The name of the ALB dedicated to the ECS Service."
}

output "alb_listener_arn" {
  value       = module.alb.http_listener_arn
  description = "The ARN of the ALB Listener corresponding to the ECS Service."
}
