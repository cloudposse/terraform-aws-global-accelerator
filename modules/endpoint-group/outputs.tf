output "endpoint_group_id" {
  value = try(aws_globalaccelerator_endpoint_group.default[0].id, null)
}
