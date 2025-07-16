terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = var.backend_bucket_name
    key    = var.global_backend_bucket_key
    region = var.region
  }
}

data "terraform_remote_state" "staging_global" {
  backend = "s3"
  config = {
    bucket = var.backend_bucket_name
    key    = var.staging_global_backend_bucket_key
    region = var.region
  }
}
