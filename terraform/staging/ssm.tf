resource "aws_ssm_parameter" "db_username" {
  name = "/staging/db_user"
  value = var.db_username
  type = "String"
}

resource "random_password" "password_generator" {
    length = 15
    special = false
}

resource "aws_ssm_parameter" "db_password" {
  name = "/staging/db_password"
  type = "String"
  value = random_password.password_generator.result
}

resource "aws_ssm_parameter" "db_name" {
       name = "/staging/db_name"
       type = "String"
       value = var.db_name
}