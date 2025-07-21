variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "backend_bucket_name" {
  type = string
}

variable "global_backend_bucket_key" {
  type = string
}

variable "domain_name" {
  type = string
}