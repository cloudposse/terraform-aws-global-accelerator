output "name" {
  description = "Name of the Global Accelerator."
  value       = module.global_accelerator.name
}

output "endpoint_group_ids" {
  description = "Global Accelerator Endpoint Group IDs."
  value       = [module.endpoint_group.id, module.endpoint_group_failover.id]
}

output "listener_ids" {
  description = "Global Accelerator Listener IDs."
  value       = module.global_accelerator.listener_ids
}

output "static_ips" {
  description = "Global Static IPs owned by the Global Accelerator."
  value       = module.global_accelerator.static_ips
}
