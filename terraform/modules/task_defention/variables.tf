variable "family_name" {
  type = string
}

variable "network_mode" {
  type = string
  default = "awsvpc"
}

variable "execution_role_arn" {
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
  type = jsonencode
}