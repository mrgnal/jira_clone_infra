variable "security_groups_ids" {
  type = list(string)
}

variable "subnets_ids" {
  type = list(string)
}

variable "alb_name" {
  type = string
}

variable "listener_port" {
  type = string
  default = "80"
}

variable "listener_rotocol" {
  type = string
  default = "HTTP"
}

variable "tg_name" {
  type = string
  default = "ecs-tg"
}

variable "vpc_id" {
  type = string
}

variable "tg_port" {
  type = string
  default = "80"
}

variable "tg_rotocol" {
  type = string
  default = "HTTP"
}

variable "target_type" {
  type = string
  default = "ip"
}
