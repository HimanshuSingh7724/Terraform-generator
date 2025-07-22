variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_subnet_ids" {
  description = "List of subnet IDs in at least 2 different AZs"
  type        = list(string)
}
