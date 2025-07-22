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

variable "ami" {
  type = string
  default = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "my_ip" {
  type = string
}

variable "domain_name" {
  type = string
}