variable "key_name" {
  description = "Name of the existing EC2 Key Pair to use for SSH access"
  type        = string
}

variable "weather_api_key" {
  description = "API key for OpenWeatherMap"
  type        = string
  sensitive   = true
}
