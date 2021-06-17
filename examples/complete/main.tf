provider "aws" {
  region = var.region
}

module "prerequisites" {
  source = "./modules/prerequisites"

  context = module.this.context

  region               = var.region
  alb_settings         = var.prerequisites.alb
  ecs_web_app_settings = var.prerequisites.ecs_web_app
  vpc_settings         = var.prerequisites.vpc
  subnet_settings      = var.prerequisites.subnets
  s3_bucket_settings   = var.prerequisites.s3_bucket
}

data "aws_alb_listener" "listener" {
  arn = module.prerequisites.alb.http_listener_arn
}

module "global_accelerator" {
  source = "../.."

  ip_address_type     = "IPV4"
  flow_logs_enabled   = true
  flow_logs_s3_prefix = "logs/"
  flow_logs_s3_bucket = module.prerequisites.s3_bucket.bucket_id

  context = module.this.context

  configurations = {
    alb = {
      listener = {
        port_range = [
          {
            from_port = data.aws_alb_listener.listener.port
            to_port   = data.aws_alb_listener.listener.port
          }
        ]
      }
      endpoint_group = {
        endpoint_configuration = [
          {
            endpoint_id = module.prerequisites.alb.alb_arn
          }
        ]
      }
    }
  }

  depends_on = [module.prerequisites]
}
