variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "ror-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_app_subnets" {
  description = "Private application subnet CIDRs"
  type        = list(string)
}

variable "private_db_subnets" {
  description = "Private database subnet CIDRs"
  type        = list(string)
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
