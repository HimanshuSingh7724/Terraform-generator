output "instance_public_ip" {
  description = "Public IP of the deployed EC2 instance"
  value       = aws_instance.web.public_ip
}

output "app_url" {
  description = "Complete URL to access the deployed app"
  value       = "http://${aws_instance.web.public_ip}/weather/Delhi"
}
