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

output "jenkins_ip" {
  value = aws_eip.jenkins_ip.public_ip
}

output "agent_role" {
  value = aws_iam_instance_profile.jenkins_agent.arn
}

#Splunk user
output "splunk_access_key_id" {
  value = aws_iam_access_key.splunk_user_key.id
}

output "splunk_secret_access_key" {
  value     = aws_iam_access_key.splunk_user_key.secret
  sensitive = true
}
