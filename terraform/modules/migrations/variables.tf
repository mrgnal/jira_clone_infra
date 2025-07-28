variable "name" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "memory_size" {
  type = number
  default = 1024
}

variable "timeout" {
  type = number
  default = 30
}

variable "subnet_ids" {
  type = list(string)
}

# variable "security_group_ids" {
#   type = list(string)
# }

variable "param_name" {
  type = string
}

variable "policies" {
  type = list(object({
    name = string
    policy = string
  }))
}

variable "role_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_cidr" {
  type = list(string)
}