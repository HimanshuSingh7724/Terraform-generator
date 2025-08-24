output "ec2_public_ip" {
  value = aws_instance.vulnguard.public_ip
}
