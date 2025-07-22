output "ssm_db" {
  value = aws_ssm_parameter.db_url.arn
  sensitive = true
}

output "dns" {
  value = module.dns
}

