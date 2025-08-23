output "vgai_public_ip" {
  value = aws_instance.vgai_server.public_ip
  description = "Public IP of VulnGuard-AI EC2 instance"
}

output "vgai_url" {
  value = "http://${aws_instance.vgai_server.public_ip}"
  description = "URL to access VulnGuard-AI"
}
