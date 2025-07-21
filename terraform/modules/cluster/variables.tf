 #ECS cluster
variable "cluster_name" {
    type = string
}

variable "container_metric" {
    type = string
    default = "enabled"
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type = number
  default = 2
}

variable "launch_type" {
    type = string
    default = "FARGATE"
}

variable "force_new_deployment" {
  type = bool
  default = true
}

variable "port" {
  type = number
}

variable "container_name" {
  type = string
}

variable "assign_public_ip" {
  type = bool
  default = false
}

variable "ecs_subnets" {
  type = list(string)
}

# variable "ecs_sg" {
#   type = list(string)
# }

#Task defenition
variable "family_name" {
  type = string
}

variable "network_mode" {
  type = string
  default = "awsvpc"
}

variable "cpu" {
  type = string
  default = "512"
}

variable "memory" {
  type = string
  default = "1024"
}

variable "container_definitions" {
  type = string
}

#IAM role
variable "role_name" {
  type = string
}

variable "policies" {
  type = list(object({
    name = string
    policy = string
  }))
}

#ALB
variable "alb_name" {
  type = string
}

# variable "alb_sg" {
#   type = list(string)
# }

variable "alb_subnets" {
  type = list(string)
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

variable "tg_rotocol" {
  type = string
  default = "HTTP"
}

variable "target_type" {
  type = string
  default = "ip"
}

variable "region" {
  type = string
}

#NAT
variable "private_rt" {
  type = string
}

#Autoscale
variable "max_capacity" {
  type = number
  default = 4
}

variable "min_capacity" {
  type = number
  default = 1
}

variable "autoscale_policy_name" {
  type = string
  default = "ecs-policy-cpu"
}

variable "target_value" {
  type = number
  default = 50.0
}

variable "scale_cooldown" {
  type = number
  default = 60
}

#SSL
variable "enable_ssl" {
  type = bool
  default = false
}

variable "certificate_arn" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}