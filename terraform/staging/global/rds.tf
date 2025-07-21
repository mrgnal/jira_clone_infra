resource "random_password" "password_generator" {
  length  = 15
  special = false
}

module "database" {
  source = "../../modules/database"

  identifier = "jira-database"
  subnet_ids = module.network.private_subnets_ids

  db_name     = var.db_name
  db_username = var.db_username
  db_password = random_password.password_generator.result

  subnets_cidr = module.network.private_subnets_cidr
  vpc_id = module.network.vpc_id
}

resource "aws_ssm_parameter" "db_url" {
  name  = "/staging/db_url"
  type  = "String"
  value = "postgres://${var.db_username}:${random_password.password_generator.result}@${module.database.db_host}:5432/${var.db_name}"
}