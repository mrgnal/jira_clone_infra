variable "region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "backend_bucket_name" {
  type = string
}

variable "ecr_app_name" {
  type = string
}

variable "ecr_migrate_name" {
  type = string
}