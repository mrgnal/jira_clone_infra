variable "region" {
    description = "AWS region"
    type = string
    default = "eu-north-1"
}

variable "backend_bucket_name" {
  type = string
}

variable "ecr_repo" {
  type = string
}

