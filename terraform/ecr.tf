resource "aws_ecr_repository" "jira_repo" {
  name                 = var.ecr_repo
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}