module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.2"
  cidr_block = var.vpc_settings.vpc_cidr_block
  context    = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.34.0"
  availability_zones   = var.subnet_settings.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = var.subnet_settings.nat_gateway_enabled
  nat_instance_enabled = var.subnet_settings.nat_instance_enabled
  context              = module.this.context
}

resource "aws_ecs_cluster" "default" {
  name = module.this.id
  tags = module.this.tags
}

module "web_app_label" {
  source          = "cloudposse/label/null"
  version         = "0.24.1"

  attributes = ["web"]
  name       = "gbl-acc"
  context    = module.this.context
}

module "ecs_web_app" {
  source  = "cloudposse/ecs-web-app/aws"
  version = "0.62.0"

  region             = var.region
  vpc_id             = module.vpc.vpc_id
  aws_logs_region    = var.region

  codepipeline_enabled = var.ecs_web_app_settings.codepipeline_enabled

  # ECS
  ecs_private_subnet_ids = module.subnets.private_subnet_ids
  ecs_cluster_arn        = aws_ecs_cluster.default.arn
  ecs_cluster_name       = aws_ecs_cluster.default.name

  # ALB
  alb_arn_suffix                             = module.alb.alb_arn_suffix
  alb_security_group                         = module.alb.security_group_id
  alb_ingress_enable_default_target_group    = true
  alb_ingress_unauthenticated_listener_arns  = [module.alb.http_listener_arn]

  context = module.web_app_label.context
}

module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.33.2"

  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = var.alb_settings.internal
  http_enabled                            = var.alb_settings.http_enabled
  http_redirect                           = var.alb_settings.http_redirect
  access_logs_enabled                     = var.alb_settings.access_logs_enabled
  cross_zone_load_balancing_enabled       = var.alb_settings.cross_zone_load_balancing_enabled
  http2_enabled                           = var.alb_settings.http2_enabled
  idle_timeout                            = var.alb_settings.idle_timeout
  ip_address_type                         = var.alb_settings.ip_address_type
  deletion_protection_enabled             = var.alb_settings.deletion_protection_enabled
  deregistration_delay                    = var.alb_settings.deregistration_delay
  health_check_path                       = var.alb_settings.health_check_path
  health_check_timeout                    = var.alb_settings.health_check_timeout
  health_check_healthy_threshold          = var.alb_settings.health_check_healthy_threshold
  health_check_unhealthy_threshold        = var.alb_settings.health_check_unhealthy_threshold
  health_check_interval                   = var.alb_settings.health_check_interval
  health_check_matcher                    = var.alb_settings.health_check_matcher
  target_group_port                       = var.alb_settings.target_group_port
  target_group_target_type                = var.alb_settings.target_group_target_type
  stickiness                              = var.alb_settings.stickiness
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.38.0"

  context = module.this.context

  force_destroy = var.s3_bucket_settings.force_destroy
}
