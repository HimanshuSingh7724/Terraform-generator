variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "docker_image" {
  description = "Docker image to run on EC2"
  type        = string
}
