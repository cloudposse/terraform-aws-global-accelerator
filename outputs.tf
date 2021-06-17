output "global_accelerator_name" {
  description = "Name of the Global Accelerator."
  value       = try(aws_globalaccelerator_accelerator.default[0].name, null)
}

output "global_accelerator_static_ips" {
  description = "Global Static IPs owned by the Global Accelerator"
  value       = try(aws_globalaccelerator_accelerator.default[0].ip_sets[0].ip_addresses, [])
}
