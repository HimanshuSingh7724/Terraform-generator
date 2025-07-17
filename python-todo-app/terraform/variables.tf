variable "private_key_content" {
  description = "Raw content of the private key"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "docker_image" {
  description = "Docker image to use for the app"
  type        = string
}
