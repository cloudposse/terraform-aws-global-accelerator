locals {
  enabled = module.this.enabled
}

resource "aws_globalaccelerator_endpoint_group" "default" {
  count = module.this.enabled ? 1 : 0

  listener_arn                  = var.listener_arn
  endpoint_group_region         = try(var.config.endpoint_endpoint_group_region, null)
  health_check_interval_seconds = try(var.config.health_check_interval_seconds, null)
  health_check_path             = try(var.config.health_check_path, null)
  health_check_port             = try(var.config.health_check_port, null)
  health_check_protocol         = try(var.config.health_check_protocol, null)
  threshold_count               = try(var.config.threshold_count, null)
  traffic_dial_percentage       = try(var.config.traffic_dial_percentage, null)

  dynamic "endpoint_configuration" {
    for_each = try(var.config.endpoint_configuration, toset([]))

    content {
      client_ip_preservation_enabled = try(endpoint_configuration.value.client_ip_preservation_enabled, null)
      endpoint_id                    = try(endpoint_configuration.value.endpoint_id, null)
      weight                         = try(endpoint_configuration.value.weight, null)
    }
  }

  dynamic "port_override" {
    for_each = try(var.config.port_override, toset([]))

    content {
      endpoint_port = try(port_override.value.endpoint_port, null)
      listener_port = try(port_override.value.listener_port, null)
    }
  }
}
