output "jenkins_access_key_id" {
  value = aws_iam_access_key.jenkins_key.id
}

output "jenkins_secret_access_key" {
  value     = aws_iam_access_key.jenkins_key.secret
  sensitive = true
}

output "ecr_app_url" {
  value       = module.app_ecr.repository_url
}

output "ecr_migrate_url" {
  value       = module.migrate_ecr.repository_url
}

output "ecr_app_arn" {
  value = module.app_ecr.repository_arn
}

output "ecr_migrate_arn" {
  value = module.migrate_ecr.repository_arn
}

output "network" {
  value = module.network
}