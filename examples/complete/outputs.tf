output "global_accelerator_name" {
  description = "Name of the Global Accelerator."
  value       = module.global_accelerator.global_accelerator_name
}

output "global_accelerator_endpoint_group_ids" {
  description = "Global Accelerator Endpoint Group IDs."
  value       = module.global_accelerator.global_accelerator_endpoint_group_ids
}

output "global_accelerator_listener_ids" {
  description = "Global Accelerator Listener IDs."
  value       = module.global_accelerator.global_accelerator_listener_ids
}

output "global_accelerator_static_ips" {
  description = "Global Static IPs owned by the Global Accelerator."
  value       = module.global_accelerator.global_accelerator_static_ips
}
