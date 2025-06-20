output "jenkins_access_key_id" {
  value = aws_iam_access_key.jenkins_key.id
}

output "jenkins_secret_access_key" {
  value     = aws_iam_access_key.jenkins_key.secret
  sensitive = true
}

output "ecr_url" {
  value = aws_ecr_repository.jira_repo.repository_url
}