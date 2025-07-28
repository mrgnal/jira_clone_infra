resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/services"
  retention_in_days = 7
}

module "app" {
  source = "../../modules/cluster"

  region = var.region
  #ALB
  alb_name = "jira-alb"
  # alb_sg  = [data.terraform_remote_state.staging_global.outputs.network.alb_sg_id]
  alb_subnets = data.terraform_remote_state.global.outputs.network.public_subnets_ids
  vpc_id = data.terraform_remote_state.global.outputs.network.vpc_id
  
  #Cluster
  cluster_name = "jira-cluster"

  #Service
  service_name     = "jira-service"
  ecs_subnets =  data.terraform_remote_state.global.outputs.network.private_subnets_ids
  # ecs_sg  = [data.terraform_remote_state.staging_global.outputs.network.ecs_sg_id]
  container_name   = "jira"
  port = 3000
  
  # ecs_subnets =  data.terraform_remote_state.staging_global.outputs.network.public_subnets_ids
  # assign_public_ip = true
  
  #Task definition
  family_name = "jira-task"
  container_definitions = jsonencode([
  {
      name             = var.container_name
      image            = "${data.terraform_remote_state.global.outputs.ecr_app_url}:production"
      essential        = true

      portMappings = [
        {
          containerPort = 3000   
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.container_name
        }
      }

      secrets = [
        { name = "DATABASE_URL",        valueFrom = data.terraform_remote_state.staging_global.outputs.ssm_db },
        { name = "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY",   valueFrom = aws_ssm_parameter.clerk_public.arn },
        { name = "CLERK_SECRET_KEY",        valueFrom = aws_ssm_parameter.clerk_private.arn },
        { name = "UPSTASH_REDIS_REST_URL",   valueFrom = aws_ssm_parameter.upstash_url.arn },
        { name = "UPSTASH_REDIS_REST_TOKEN", valueFrom = aws_ssm_parameter.upstash_token.arn }
      ]
    }
  ])

  #IAM
  role_name = "ecsExecutionRole"
  policies = [
    {
      name = "ecs-logging-policy"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            Resource = "*"
          }
        ]
      })
    },
    {
      name = "ecs-ssm-policy"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect = "Allow"
            Action = [
                  "ssm:GetParameters",
                  "ssm:GetParameter",
                  "ssm:GetParametersByPath"
            ]
            Resource = [
              aws_ssm_parameter.clerk_public.arn,
              aws_ssm_parameter.clerk_private.arn,
              aws_ssm_parameter.upstash_token.arn,
              aws_ssm_parameter.upstash_url.arn,
              data.terraform_remote_state.staging_global.outputs.ssm_db
            ]
          }
        ]
      })
    },
    {
      name = "ecs-ecr-policy"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = [
            "ecr:GetAuthorizationToken",
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ]
          Resource = data.terraform_remote_state.global.outputs.ecr_app_arn
        }
        ]
      })
    }
  ]

  #Endpoints
  # private_rt = [data.terraform_remote_state.staging_global.outputs.network.private_rt]
  # private_rt = [data.terraform_remote_state.staging_global.outputs.network.public_rt]
  # endpoint_sg = [data.terraform_remote_state.staging_global.outputs.network.endpoint_sg_id]

  #NAT
  private_rt = data.terraform_remote_state.global.outputs.network.private_rt

  # DNS
  enable_ssl = true
  certificate_arn = data.terraform_remote_state.staging_global.outputs.dns.certificate_arn
  zone_id = data.terraform_remote_state.staging_global.outputs.dns.zone_id
  domain_name = var.domain_name

}