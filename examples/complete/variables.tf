variable "region" {
  type        = string
  description = "AWS region"
}

variable "prerequisites" {
  type        = any
  description = "Map containing maps of variables to pass to pre-requisite modules."
}
