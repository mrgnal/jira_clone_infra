variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  default = "MUTABLE"
}

variable "force_delete" {
  default = true
}

variable "scan_on_push" {
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "lifecycle_policy" {
  type        = string
  description = "JSON-formatted lifecycle policy"
}
