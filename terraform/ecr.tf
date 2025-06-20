resource "aws_ecr_repository" "jira_repo" {
  name                 = var.ecr_repo
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_lifecycle_policy" "jira_ecr_lifecycle" {
  repository = aws_ecr_repository.jira_repo.name

  policy = <<EOF
{
    "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images above 10",
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