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
  sensitive = true
}

variable "clerk_private" {
  type = string
  sensitive = true
}

variable "upstash_url" {
  type = string
}

variable "upstash_token" {
  type = string
  sensitive = true
}

variable "container_name" {
  type = string
}

variable "domain_name" {
  type = string
}

#Splunk
variable "splunk_hec_url" {
  type = string
}

variable "splunk_hec_token" {
  type = string  
  sensitive = true
}

variable "splunk_api_url" {
  type = string
}

variable "splunk_ingres_url" {
  type = string
}

variable "splunk_access_token" {
  type = string
  sensitive = true
}