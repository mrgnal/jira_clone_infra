resource "aws_ssm_parameter" "clerk_public" {
  name  = "/staging/clerk_public"
  type  = "String"
  value = var.clerk_public
}

resource "aws_ssm_parameter" "clerk_private" {
  name  = "/staging/clerk_private"
  type  = "String"
  value = var.clerk_private
}

resource "aws_ssm_parameter" "upstash_url" {
  name  = "/staging/upstash_url"
  type  = "String"
  value = var.upstash_url
}

resource "aws_ssm_parameter" "upstash_token" {
  name  = "/staging/upstash_token"
  type  = "String"
  value = var.upstash_token
}

resource "aws_ssm_parameter" "splunk_access_token" {
  name = "/staging/splunk_access_token"
  type = "String"
  value = var.splunk_access_token
}

resource "aws_ssm_parameter" "splunk_hec_token" {
  name = "/staging/splunk_hec_token"
  type = "String"
  value = var.splunk_hec_token
}