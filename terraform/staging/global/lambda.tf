module "migrations" {
  source = "../../modules/migrations"
  
  name = "jira-migrations"
  image_uri ="${data.terraform_remote_state.global.outputs.ecr_migrate_url}:latest"

  vpc_id = module.network.vpc_id
  subnets_cidr = module.network.private_subnets_cidr
  subnet_ids = module.network.private_subnets_ids
  # security_group_ids = [module.network.ecs_sg_id]

  db_url = aws_ssm_parameter.db_url.value
  
  role_name = "migrationRole"
    policies = [
    {
      name = "lambda-ssm-policy"
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
              aws_ssm_parameter.db_url.arn,
            ]
          }
        ]
      })
    },
    {
      name = "lambda-ecr-policy"
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
          Resource = data.terraform_remote_state.global.outputs.ecr_migrate_arn
        }
        ]
      })
    }
  ]
}