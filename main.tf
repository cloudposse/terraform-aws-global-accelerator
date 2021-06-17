locals {
  enabled           = module.this.enabled
  flow_logs_enabled = local.enabled && var.flow_logs_enabled
  configurations    = local.enabled ? var.configurations : {}
  listeners         = {for name, configuration in local.configurations : name => configuration.listener }
  endpoint_groups   = {for name, configuration in local.configurations : name => configuration.endpoint_group }
}

resource "aws_globalaccelerator_accelerator" "default" {
  count = local.enabled ? 1 : 0

  name            = module.this.id
  ip_address_type = var.ip_address_type
  enabled         = true

  dynamic "attributes" {
    for_each = local.flow_logs_enabled ? toset([true]) : toset([])

    content {
      flow_logs_enabled   = true
      flow_logs_s3_bucket = var.flow_logs_s3_bucket
      flow_logs_s3_prefix = var.flow_logs_s3_prefix
    }
  }

  tags = module.this.tags
}

resource "aws_globalaccelerator_listener" "default" {
  for_each = local.listeners

  accelerator_arn = aws_globalaccelerator_accelerator.default[0].id
  client_affinity = try(each.value.cluster_affinity, null)
  protocol        = try(each.value.protocol, "TCP")

  dynamic "port_range" {
    for_each = try(each.value.port_range, [{
      from_port = 80
      to_port   = 80
    }])

    content {
      from_port = try(port_range.value.from_port, null)
      to_port   = try(port_range.value.to_port, null)
    }
  }
}

resource "aws_globalaccelerator_endpoint_group" "default" {
  for_each = local.endpoint_groups

  listener_arn                  = aws_globalaccelerator_listener.default[each.key].id
  endpoint_group_region         = try(each.value.endpoint_endpoint_group_region, null)
  health_check_interval_seconds = try(each.value.health_check_interval_seconds, null)
  health_check_path             = try(each.value.health_check_path, null)
  health_check_port             = try(each.value.health_check_port, null)
  health_check_protocol         = try(each.value.health_check_protocol, null)
  threshold_count               = try(each.value.threshold_count, null)
  traffic_dial_percentage       = try(each.value.traffic_dial_percentage, null)

  dynamic "endpoint_configuration" {
    for_each = try(each.value.endpoint_configuration, toset([]))

    content {
      client_ip_preservation_enabled = try(endpoint_configuration.value.client_ip_preservation_enabled, null)
      endpoint_id                    = try(endpoint_configuration.value.endpoint_id, null)
      weight                         = try(endpoint_configuration.value.weight, null)
    }
  }

  dynamic "port_override" {
    for_each = try(each.value.port_override, toset([]))

    content {
      endpoint_port = try(port_override.value.endpoint_port, null)
      listener_port = try(port_override.value.listener_port, null)
    }
  }
}
