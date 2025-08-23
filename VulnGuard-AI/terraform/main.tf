provider "aws" {
  region = var.region
}

# Security Group for VulnGuard-AI
resource "aws_security_group" "vgai_sg" {
  name        = "vgai-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VulnGuardAI-SG"
  }
}

# EC2 Instance
resource "aws_instance" "vgai_server" {
  ami                    = "ami-0945610b37068d87a"
  instance_type           = "t2.micro"
  key_name                = var.key_name
  vpc_security_group_ids  = [aws_security_group.vgai_sg.id]

  # Install Docker and run VulnGuard-AI container
  user_data = <<-EOF
              #!/bin/bash
              # Update OS and install Docker
              yum update -y
              amazon-linux-extras enable docker -y
              yum install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Login to DockerHub and run container
              docker login -u ${var.docker_username} -p ${var.docker_password}
              docker pull vuln-guard-ai
              docker run -d -p 80:8000 --restart unless-stopped --name vulnguard-ai vuln-guard-ai
              EOF

  tags = {
    Name = "VulnGuardAI-Server"
  }
}

# Output the public IP of the EC2 instance
output "vgai_server_public_ip" {
  value = aws_instance.vgai_server.public_ip
}
