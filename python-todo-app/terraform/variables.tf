variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}
variable "docker_image" {
  description = "Docker image to run"
  type        = string
  default     = "your-docker-image"
