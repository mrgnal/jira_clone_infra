variable "vpc_cidr" {
    type = string
}

variable "tags" {
    type = map(string)
    default = {
    "Project" = "jira"
    }
}

variable "pulic_subnets" {
    type = map(object({
    cidr = string
    az   = string
    }))
}

variable "private_subnets" {
    type = map(object({
    cidr = string
    az   = string
    }))
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "endpoint_sg_id" {
  type = string
}