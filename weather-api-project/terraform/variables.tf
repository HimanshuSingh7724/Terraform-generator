variable "my_key" {
  description = "Name of the EC2 key pair to use"
  type        = string
}


variable "weather_api_key" {
  description = "API key for OpenWeatherMap"
  type        = string
  sensitive   = true
}
