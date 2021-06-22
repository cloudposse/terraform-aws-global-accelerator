variable "listener_arn" {
  type        = string
  description = "The ARN of the Global Accelerator Listener which this Endpoint Group will be associated with."
}

variable "config" {
  type        = any
  description = <<-eot
  Endpoint Group configuration.

  This object needs to be fully compliant with the `aws_globalaccelerator_endpoint_group` resource, except for `listener_arn`, which is specified separately.
  note that the values for `endpoint_configuration` and `port_override` within each object in `endpoint_groups` should be lists.
  for more information, see: [aws_globalaccelerator_endpoint_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group).
  eot
}
