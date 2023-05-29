# resource "aws_service_discovery_service" "this" {
#   name = var.name

#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.this.id

#     dns_records {
#       ttl  = 10
#       type = "A"
#     }

#     routing_policy = "MULTIVALUE"
#   }

#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }

# module "container_image_ecr" {

#   source  = "terraform-aws-modules/ecr/aws"
#   version = "~> 1.4"

#   repository_name = var.container_name

#   repository_force_delete           = true
#   create_lifecycle_policy           = false
#   repository_read_access_arns       = [one(data.aws_iam_roles.ecs_core_infra_exec_role.arns)]
#   repository_read_write_access_arns = [module.codepipeline_ci_cd.codepipeline_role_arn]

#   tags = var.tags
# }

# module "ecs_service_definition" {

#   source  = "terraform-aws-modules/ecs/aws//modules/service"
#   version = "~> 5.0"

#   name          = var.name
#   desired_count = 3
#   cluster_arn   = module.ecs.cluster_arn

#   subnet_ids = module.vpc.private_subnets
#   security_group_rules = {
#     ingress_alb_service = {
#       type                     = "ingress"
#       from_port                = var.container_port
#       to_port                  = var.container_port
#       protocol                 = "tcp"
#       description              = "Service port"
#       source_security_group_id = module.service_alb.security_group_id
#     }
#     egress_all = {
#       type        = "egress"
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }

#   load_balancer = [{
#     container_name   = var.container_name
#     container_port   = var.container_port
#     target_group_arn = element(module.service_alb.target_group_arns, 0)
#   }]

#   service_registries = {
#     registry_arn = aws_service_discovery_service.this.arn
#   }

#   # Task Definition
#   enable_execute_command = true
#   create_iam_role        = false
#   task_exec_iam_role_arn = one(data.aws_iam_roles.ecs_core_infra_exec_role.arns)
#   task_exec_secret_arns = [
#     data.aws_secretsmanager_secret.github_token.arn,
#     data.aws_secretsmanager_secret.postgresdb_master_password.arn,
#   ]
#   task_exec_ssm_param_arns = [
#     aws_ssm_parameter.base_url.arn,
#     aws_ssm_parameter.postgres_host.arn,
#     aws_ssm_parameter.postgres_port.arn,
#     aws_ssm_parameter.postgres_user.arn,
#   ]

#   container_definitions = {
#     main_container = {
#       name                     = var.container_name
#       image                    = module.container_image_ecr.repository_url
#       readonly_root_filesystem = false
#       secrets = [
#         { name = "GITHUB_TOKEN", valueFrom = data.aws_secretsmanager_secret.github_token.arn },
#         { name = "BASE_URL", valueFrom = aws_ssm_parameter.base_url.name },
#         { name = "POSTGRES_HOST", valueFrom = aws_ssm_parameter.postgres_host.name },
#         { name = "POSTGRES_PORT", valueFrom = aws_ssm_parameter.postgres_port.name },
#         { name = "POSTGRES_USER", valueFrom = aws_ssm_parameter.postgres_user.name },
#         { name = "POSTGRES_PASSWORD", valueFrom = data.aws_secretsmanager_secret.postgresdb_master_password.arn }
#       ]

#       port_mappings = [{
#         protocol : "tcp",
#         containerPort : var.container_port
#         hostPort : var.container_port
#       }]
#     }
#   }

#   ignore_task_definition_changes = true

#   tags = var.tags
# }

# module "codepipeline_s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "~> 3.0"

#   bucket = "codepipeline-${var.name}-${var.region}"

#   force_destroy = true

#   attach_deny_insecure_transport_policy = true
#   attach_require_latest_tls_policy      = true

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true

#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm = "AES256"
#       }
#     }
#   }

#   tags = var.tags
# }

# resource "aws_sns_topic" "codestar_notification" {
#   name = var.name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid      = "WriteAccess"
#         Effect   = "Allow"
#         Action   = "sns:Publish"
#         Resource = "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.name}"
#         Principal = {
#           Service = "codestar-notifications.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = var.tags
# }

# module "codebuild_ci" {
#   depends_on = [
#     module.container_image_ecr
#   ]

#   source = "./cicd/codebuild"

#   name           = "codebuild-${var.name}"
#   service_role   = module.codebuild_ci.codebuild_role_arn
#   buildspec_path = "buildspec.yml"
#   s3_bucket      = module.codepipeline_s3_bucket

#   environment = {
#     image           = "aws/codebuild/standard:7.0"
#     privileged_mode = true
#     environment_variables = [
#       {
#         name  = "REPO_URL"
#         value = module.container_image_ecr.repository_url
#         }, {
#         name  = "CONTAINER_NAME"
#         value = var.container_name
#         }, {
#         name  = "BASE_URL"
#         value = "http://${module.service_alb.lb_dns_name}"
#       },
#     ]
#   }

#   create_iam_role = true
#   iam_role_name   = "${var.name}-codebuild"
#   ecr_repository  = module.container_image_ecr.repository_arn

#   tags = var.tags
# }

# module "codepipeline_ci_cd" {
#   source = "./cicd/codepipeline"

#   name         = "pipeline-${var.name}"
#   service_role = module.codepipeline_ci_cd.codepipeline_role_arn
#   s3_bucket    = module.codepipeline_s3_bucket
#   sns_topic    = aws_sns_topic.codestar_notification.arn

#   stage = [{
#     name = "Source"
#     action = [{
#       name             = "Source"
#       category         = "Source"
#       owner            = "ThirdParty"
#       provider         = "GitHub"
#       version          = "1"
#       input_artifacts  = []
#       output_artifacts = ["SourceArtifact"]
#       configuration = {
#         OAuthToken           = data.aws_secretsmanager_secret_version.github_token.secret_string
#         Owner                = var.repository_owner
#         Repo                 = var.repository_name
#         Branch               = var.repository_branch
#         PollForSourceChanges = true
#       }
#     }],
#     }, {
#     name = "Build"
#     action = [{
#       name             = "Build_app"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       version          = "1"
#       input_artifacts  = ["SourceArtifact"]
#       output_artifacts = ["BuildArtifact_app"]
#       configuration = {
#         ProjectName = module.codebuild_ci.project_id
#       }
#     }],
#     }, {
#     name = "Deploy"
#     action = [{
#       name            = "Deploy_app"
#       category        = "Deploy"
#       owner           = "AWS"
#       provider        = "ECS"
#       version         = "1"
#       input_artifacts = ["BuildArtifact_app"]
#       configuration = {
#         ClusterName = module.ecs.cluster_name
#         ServiceName = var.name
#         FileName    = "imagedefinition.json"
#       }
#     }],
#   }]

#   create_iam_role = true
#   iam_role_name   = "${var.name}-pipeline"

#   tags = var.tags
# }

