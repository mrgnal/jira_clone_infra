variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#S3 
variable "global_backend_bucket_key" {
  type = string
}

variable "staging_global_backend_bucket_key" {
  type = string
}

variable "backend_bucket_name" {
  type = string
}

#APIs for app
variable "clerk_public" {
  type = string
}

variable "clerk_private" {
  type = string
}

variable "upstash_url" {
  type = string
}

variable "upstash_token" {
  type = string
}

variable "container_name" {
  type = string
}