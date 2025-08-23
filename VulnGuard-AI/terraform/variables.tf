variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub password"
  type        = string
}
