variable "subnet_ids" {
  type = list(string)
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

# variable "rds_sg" {
#   type = list(string)
# }

variable "storage_encrypted" {
  type = bool
  default = true
}

variable "multi_az" {
  type = bool
  default = false
}

variable "skip_final_snapshot" {
  type = bool
  default = true
}

variable "publicly_accessible" {
  type = string
  default = false
}

variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "engine_version" {
  type = string
  default = "16.4"
}

variable "engine" {
  type = string
  default = "postgres"
}

variable "allocated_storage" {
    type = number
    default = 20
}

variable "identifier" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_cidr" {
  type = list(string)
}