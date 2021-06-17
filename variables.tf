variable "configurations" {
  description = <<-EOT
  Map of configurations for the Global Accelerator.
  Each configuration's value for `listener` needs to be fully compliant with the `aws_globalaccelerator_listener` resource.
  Each configuration's value for `endpoint_group` needs to be fully compliant with the `aws_globalaccelerator_listener` resource.
  For more information, see: [aws_globalaccelerator_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_listener) and
  [aws_globalaccelerator_endpoint_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group).

  Note that for `listener`, the value for `port_range` within each map should be a list.
  Note that for `endpoint_group`, the values for `endpoint_configuration` and `port_override` within each map should be lists.
  EOT
  type = map(object({
    listener       = any
    endpoint_group = any
  }))
  default = {}
}

variable "flow_logs_enabled" {
  description = "Enable or disable flow logs for the Global Accelerator."
  type        = bool
  default     = false
}

variable "flow_logs_s3_bucket" {
  description = "The name of the S3 Bucket for the Accelerator Flow Logs. Required if `var.flow_logs_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "flow_logs_s3_prefix" {
  description = "The Object Prefix within the S3 Bucket for the Accelerator Flow Logs. Required if `var.flow_logs_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "ip_address_type" {
  description = "The address type to use for the Global Accelerator. At this moment, [only IPV4 is supported](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_accelerator#ip_address_type)."
  type        = string
  default     = "IPV4"
  validation {
    condition     = var.ip_address_type == "IPV4"
    error_message = "Only IPV4 is supported."
  }
}
