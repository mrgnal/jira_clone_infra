output "ssm_db" {
  value = aws_ssm_parameter.db_url.arn
  sensitive = true
}

output "network" {
  value = module.network
}
