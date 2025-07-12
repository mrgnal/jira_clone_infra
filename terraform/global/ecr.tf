module "app_ecr" {
  source = "../modules/ecr"
  name = var.ecr_app_name
  tags = {
    Project     = "jira"
  }

  lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images above 2",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

module "migrate_ecr" {
  source = "../modules/ecr"
  name = var.ecr_migrate_name

  tags = {
    Project = "jira"
  }

  lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images above 2",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF  
}