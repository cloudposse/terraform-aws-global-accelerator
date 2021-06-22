module "ecs_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["ecs"]
  context    = module.this.context
}

resource "aws_ecs_cluster" "default" {
  name               = module.this.id
  capacity_providers = ["FARGATE"]

  tags = module.ecs_label.tags
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.57.0"

  container_name               = var.container_configuration.name
  container_image              = var.container_configuration.image
  container_memory             = var.container_configuration.memory
  container_memory_reservation = var.container_configuration.memory_reservation
  container_cpu                = var.container_configuration.cpu
  essential                    = true
  readonly_root_filesystem     = false
  environment                  = []
  port_mappings = [
    {
      containerPort = var.container_configuration.port
      hostPort      = var.host_port
      protocol      = "tcp"
    }
  ]
}


module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.33.1"

  context = module.ecs_label.context

  vpc_id                      = var.vpc_id
  subnet_ids                  = var.vpc_public_subnet_ids
  internal                    = false
  http_enabled                = true
  access_logs_enabled         = false
  deletion_protection_enabled = false
  health_check_path           = var.health_check_path
  # without passing the following variable, this module uses a label for the tg name which appends "default" as an attribute,
  # which in conjunction with the randId attribute in tests is too long.
  target_group_name = module.ecs_label.id
}

module "ecs_alb_service_task" {
  source  = "cloudposse/ecs-alb-service-task/aws"
  version = "0.57.0"
  context = module.ecs_label.context

  container_definition_json      = module.container_definition.json_map_encoded_list
  ecs_cluster_arn                = aws_ecs_cluster.default.arn
  launch_type                    = "FARGATE"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.vpc_private_subnet_ids
  ignore_changes_task_definition = false
  network_mode                   = "awsvpc"
  assign_public_ip               = false
  desired_count                  = 1
  task_memory                    = var.container_configuration.memory
  task_cpu                       = var.container_configuration.cpu
  ecs_load_balancers = [
    {
      container_name   = var.container_configuration.name
      container_port   = var.container_configuration.port
      elb_name         = null # loadBalancerName and targetGroupArn cannot both be specified
      target_group_arn = module.alb.default_target_group_arn
    }
  ]

  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      cidr_blocks              = [var.vpc_cidr_block]
      source_security_group_id = null
      description              = "Allow all inbound traffic from within VPC"
    }
  ]
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = module.alb.alb_arn
  port              = var.alb_listener_port
  default_action {
    type             = "forward"
    target_group_arn = module.alb.default_target_group_arn
  }
}
