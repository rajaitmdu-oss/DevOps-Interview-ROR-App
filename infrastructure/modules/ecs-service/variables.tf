variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "private_app_subnet_ids" {
  type = list(string)
}