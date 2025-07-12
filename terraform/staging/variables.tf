variable "region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "backend_bucket_name" {
  type = string
}

variable "backend_bucket_key" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}