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

variable "task_definition" {
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

variable "target_group_arn" {
  type = string
}

variable "container_port" {
  type = number
  default =3000
}

variable "container_name" {
  type = string
}

variable "assign_public_ip" {
  type = bool
  default = false
}

variable "subnets_ids" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}