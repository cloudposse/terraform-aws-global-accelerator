region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "gbl-acc"

alb_listener_port = 80

availability_zones = ["us-east-2a", "us-east-2b"]

ecs_configuration = {
  container_name               = "default-backend"
  container_image              = "cloudposse/default-backend"
  container_port               = 80
  container_memory             = 512
  container_memory_reservation = 256
  container_cpu                = 256
  health_check_path            = "/healthz"
  host_port                    = 80
}

vpc_cidr_block = "172.16.0.0/16"
