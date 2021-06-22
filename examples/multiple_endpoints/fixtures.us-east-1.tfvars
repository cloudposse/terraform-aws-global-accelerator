region = "us-east-1"

namespace = "eg"

environment = "gbl"

stage = "test"

name = "gbl-acc"

alb_listener_port = 80

availability_zones = ["us-east-1a", "us-east-1b"]

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

failover_region = "us-west-2"

failover_vpc_cidr_block = "172.17.0.0/16"

failover_availability_zones = ["us-west-2a", "us-west-2b"]
