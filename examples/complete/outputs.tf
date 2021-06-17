output "global_accelerator_static_ips" {
  description = "Global Static IPs owned by the Global Accelerator"
  value       = module.global_accelerator.global_accelerator_static_ips
}
