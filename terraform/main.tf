provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${var.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${var.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.name}-default" }

  tags = var.tags
}


resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "default.${var.name}.local"
  description = "Service discovery namespace.clustername.local"
  vpc         = module.vpc.vpc_id

  tags = var.tags
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = "${var.name}-cluster"

  cluster_service_connect_defaults = {
    namespace = aws_service_discovery_private_dns_namespace.this.arn
  }

  fargate_capacity_providers = {
    FARGATE      = {}
    FARGATE_SPOT = {}
  }

  # Shared task execution role
  create_task_exec_iam_role = true
  # Allow read access to all SSM params in current account for demo
  task_exec_ssm_param_arns = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/*"]
  # Allow read access to all secrets in current account for demo
  task_exec_secret_arns = ["arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:*"]

  tags = var.tags
}

module "rds_postgresdb" {

  source  = "terraform-aws-modules/rds/aws"

  identifier = var.name

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 30


  db_name  = var.name
  username = "coder"
  password = data.aws_secretsmanager_secret_version.postgresdb_master_password.secret_string
  port     = 5432

  create_random_password = false

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [module.db_security_group.security_group_id]

  skip_final_snapshot     = true
  deletion_protection     = false

}

module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.name
  description = "Complete PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.vpc_cidr
    },
  ]

  tags = var.tags
}

# # ################################################################################
# # # ECS Blueprint
# # ################################################################################

module "service_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.3"

  name = "${var.name}-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [for cidr_block in module.vpc.private_subnets_cidr_blocks : cidr_block]
    }
  }

  http_tcp_listeners = [
    {
      port               = "80"
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${var.name}-tg"
      backend_protocol = "HTTP"
      backend_port     = var.container_port
      target_type      = "ip"
      health_check = {
        path    = "/"
        port    = var.container_port
        matcher = "200-299"
      }
    },
  ]

  tags = var.tags
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

data "aws_secretsmanager_secret" "postgresdb_master_password" {
  name = var.postgresdb_master_password
}

data "aws_secretsmanager_secret_version" "postgresdb_master_password" {
  secret_id = data.aws_secretsmanager_secret.postgresdb_master_password.id
}

data "aws_secretsmanager_secret" "github_token" {
  name = var.github_token_secret_name
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

data "aws_iam_roles" "ecs_core_infra_exec_role" {
  name_regex = "${var.name}-cluster*"
}

resource "aws_ssm_parameter" "postgres_host" {
  name  = "postgres_host"
  type  = "String"
  value = module.rds_postgresdb.db_instance_address
}

resource "aws_ssm_parameter" "postgres_port" {
  name  = "postgres_port"
  type  = "String"
  value = 5432
}

resource "aws_ssm_parameter" "postgres_user" {
  name  = "postgres_user"
  type  = "String"
  value = "coder"
}

resource "aws_ssm_parameter" "base_url" {
  name  = "base_url"
  type  = "String"
  value = "http://${module.service_alb.lb_dns_name}"
}