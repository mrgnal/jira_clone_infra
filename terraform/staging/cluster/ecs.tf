resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/services"
  retention_in_days = 7
}

module "app" {
  source = "../../modules/cluster"

  region = var.region
  #ALB
  alb_name = "jira-alb"
  alb_subnets = data.terraform_remote_state.global.outputs.network.public_subnets_ids
  vpc_id = data.terraform_remote_state.global.outputs.network.vpc_id
  
  #Cluster
  cluster_name = "jira-cluster"

  #Service
  service_name     = "jira-service"
  ecs_subnets =  data.terraform_remote_state.global.outputs.network.private_subnets_ids
  container_name   = "jira"
  port = 3000
  min_capacity = 2

  
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
      # logConfiguration = {
      #   logDriver = "splunk"
      #   options = {
      #     splunk-url = var.splunk_hec_url
      #     splunk-token = var.splunk_hec_token
      #   }
      # }

      environment = [
        { name = "SPLUNK_HEC_URL", value = "https://prd-p-e77pr.splunkcloud.com:8088"},
        { name = "SPLUNK_API_URL", value = "https://api.eu1.signalfx.com"},
        { name = "SPLUNK_INGRES_URL", value = "https://ingest.eu1.signalfx.com" }
      ]

      secrets = [
        { name = "DATABASE_URL",        valueFrom = data.terraform_remote_state.staging_global.outputs.ssm_db },
        { name = "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY",   valueFrom = aws_ssm_parameter.clerk_public.arn },
        { name = "CLERK_SECRET_KEY",        valueFrom = aws_ssm_parameter.clerk_private.arn },
        { name = "UPSTASH_REDIS_REST_URL",   valueFrom = aws_ssm_parameter.upstash_url.arn },
        { name = "UPSTASH_REDIS_REST_TOKEN", valueFrom = aws_ssm_parameter.upstash_token.arn },
        { name = "SPLUNK_HEC_TOKEN", valueFrom = aws_ssm_parameter.splunk_hec_token.arn },
        { name = "SPLUNK_ACCESS_TOKEN", valueFrom = aws_ssm_parameter.splunk_access_token.arn}
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
              aws_ssm_parameter.splunk_hec_token.arn,
              aws_ssm_parameter.splunk_access_token.arn,
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

  #NAT
  private_rt = data.terraform_remote_state.global.outputs.network.private_rt

  # DNS
  enable_ssl = true
  certificate_arn = data.terraform_remote_state.staging_global.outputs.dns.certificate_arn
  zone_id = data.terraform_remote_state.staging_global.outputs.dns.zone_id
  domain_name = var.domain_name

}