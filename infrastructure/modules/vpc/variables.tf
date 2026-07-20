variable "project_name" {
  description = "Project name"
  type        = string

}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
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