variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
}

variable "private_key" {
  description = "EC2 private key for SSH connection"
  type        = string
}
