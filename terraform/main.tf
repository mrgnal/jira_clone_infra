terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    }
    
}

provider "aws" {
    region = var.region
}


resource "aws_s3_bucket" "terraform_state" {
    bucket = var.backend_bucket_name
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}