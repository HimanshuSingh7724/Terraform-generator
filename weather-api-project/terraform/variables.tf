variable "my_key" {
  description = "Name of the existing EC2 Key Pair to use for SSH access"
  type        = string
}

variable "weather_api_key" {
  description = "API key for the weather app"
  type        = string
}

variable "docker_image" {
  description = "Full Docker Hub image name (e.g. username/weather-app)"
  type        = string
}
