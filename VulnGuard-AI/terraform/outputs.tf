output "ec2_public_ip" {
  description = "Public IP of VulnGuard-AI EC2 instance"
  value       = aws_instance.vgai_server.public_ip
}
