variable "listener_arn" {
  type        = string
  description = "The ARN of the Global Accelerator Listener which this Endpoint Group will be associated with."
}

variable "config" {
  type        = any
  description = <<-EOT
  Endpoint Group configuration.

  This object needs to be fully compliant with the `aws_globalaccelerator_endpoint_group` resource, except for the following differences:

  * `listener_arn`, which is specified separately, is omitted.
  * The values for `endpoint_configuration` and `port_override` within each object in `endpoint_groups` should be lists.
  * Inside the `endpoint_configuration` block, `endpoint_lb_name` can be supplied in place of `endpoint_id` as long as it is a valid unique name for an existing ALB or NLB.

  For more information, see: [aws_globalaccelerator_endpoint_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group).
  EOT
}
