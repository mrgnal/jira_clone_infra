variable "event_rule_name" {
    type = string
}

variable "event_pattern" {
  type = string
}

variable "family_name" {
  type = string
}

variable "network_mode" {
  type = string
}

variable "cpu" {
  type = string
  default = "512"
}

variable "memory" {
  type = string
  default = "1024"
}

variable "family_name" {
  type = string
}

variable "container_definitions" {
  type = string
}

variable "role_name" {
  type = string
}

variable "policies" {
  type = list(object({
    name = string
    policy = string
  }))
}

variable "target_id" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

