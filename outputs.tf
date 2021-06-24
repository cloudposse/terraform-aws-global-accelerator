output "name" {
  description = "Name of the Global Accelerator."
  value       = try(aws_globalaccelerator_accelerator.default[0].name, null)
}

output "dns_name" {
  description = "DNS name of the Global Accelerator."
  value       = try(aws_globalaccelerator_accelerator.default[0].dns_name, null)
}

output "listener_ids" {
  description = "Global Accelerator Listener IDs."
  value       = [for global_accelerator_listener in aws_globalaccelerator_listener.default : global_accelerator_listener.id]
}

output "static_ips" {
  description = "Global Static IPs owned by the Global Accelerator."
  value       = try(flatten(aws_globalaccelerator_accelerator.default[0].ip_sets[*].ip_addresses), [])
}
