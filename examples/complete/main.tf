provider "aws" {
  region = var.region
}

module "vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.1.0"
  ipv4_primary_cidr_block = var.vpc_cidr_block
  context                 = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "2.3.0"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  context              = module.this.context
}

module "ecs" {
  source = "../modules/ecs"

  context = module.this.context

  region            = var.region
  alb_listener_port = var.alb_listener_port
  container_configuration = {
    name               = var.ecs_configuration.container_name
    image              = var.ecs_configuration.container_image
    port               = var.ecs_configuration.container_port
    memory             = var.ecs_configuration.container_memory
    memory_reservation = var.ecs_configuration.container_memory_reservation
    cpu                = var.ecs_configuration.container_cpu
  }
  health_check_path      = var.ecs_configuration.health_check_path
  host_port              = var.ecs_configuration.host_port
  vpc_cidr_block         = module.vpc.vpc_cidr_block
  vpc_private_subnet_ids = module.subnets.private_subnet_ids
  vpc_public_subnet_ids  = module.subnets.public_subnet_ids
  vpc_id                 = module.vpc.vpc_id
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.38.0"

  context = module.this.context

  force_destroy = true
}

module "global_accelerator" {
  source = "../.."

  context = module.this.context

  ip_address_type     = "IPV4"
  flow_logs_enabled   = true
  flow_logs_s3_prefix = "logs/"
  flow_logs_s3_bucket = module.s3_bucket.bucket_id

  listeners = [
    {
      client_affinity = "NONE"
      protocol        = "TCP"
      port_ranges = [
        {
          from_port = var.alb_listener_port
          to_port   = var.alb_listener_port
        }
      ]
    }
  ]
}

module "endpoint_group" {
  source = "../../modules/endpoint-group"

  context = module.this.context

  listener_arn = module.global_accelerator.listener_ids[0]
  config = {
    endpoint_region = var.region
    endpoint_configuration = [
      {
        endpoint_lb_name = module.ecs.alb_name
      }
    ]
  }

  depends_on = [module.ecs]
}
