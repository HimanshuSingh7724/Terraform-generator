output "ec2_public_ip" {
  value = aws_instance.k8s_server.public_ip
}

output "private_key_path" {
  value = local_file.private_key.filename
}
