locals {
  enabled           = module.this.enabled
  flow_logs_enabled = local.enabled && var.flow_logs_enabled
  listeners         = local.enabled ? { for index, listener in var.listeners : format("listener-%v", index) => listener } : {}
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
    for_each = try(each.value.port_ranges, [{
      from_port = 80
      to_port   = 80
    }])

    content {
      from_port = try(port_range.value.from_port, null)
      to_port   = try(port_range.value.to_port, null)
    }
  }
}
