region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "global_accelerator"

prerequisites = {
  alb = {
    internal = false
    http_enabled = true
    http_redirect = false
    http_port = 80
    access_logs_enabled = false
    cross_zone_load_balancing_enabled = false
    http2_enabled = true
    idle_timeout = 60
    ip_address_type = "ipv4"
    deletion_protection_enabled = false
    deregistration_delay = 15
    health_check_path = "/"
    health_check_timeout = 10
    health_check_healthy_threshold = 2
    health_check_unhealthy_threshold = 2
    health_check_interval = 15
    health_check_matcher = "200-399"
    target_group_port = 80
    target_group_target_type = "ip"
    stickiness = {
      cookie_duration = 60
      enabled         = true
    }
  }
  ecs_web_app = {
    codepipeline_enabled = false
  }
  vpc = {
    vpc_cidr_block = "172.16.0.0/16"
  }
  subnets = {
    availability_zones = ["us-east-2a", "us-east-2b"]
    nat_gateway_enabled = false
    nat_instance_enabled = false
  }
  s3_bucket = {
    force_destroy = true # enable force-destroy such that automated tests can destroy this bucket without an error, even if objects/versions remain
    # No need for a special bucket policy as the Global Accelerator Service will automatically attach one, similar to CloudFront logging
    # see: https://docs.aws.amazon.com/global-accelerator/latest/dg/monitoring-global-accelerator.flow-logs.html
  }
}

