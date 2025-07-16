variable "vpc_cidr" {
    type = string
}

variable "tags" {
    type = map(string)
    default = {
    "Project" = "jira"
    }
}

variable "public_subnets" {
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