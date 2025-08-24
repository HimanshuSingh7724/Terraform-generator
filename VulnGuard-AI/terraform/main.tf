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

# EC2 Instance with Auto Docker Setup
resource "aws_instance" "vgai_server" {
  ami                    = "ami-0fa3a4915333e2850" # Amazon Linux 2023 (us-west-1)
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vgai_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -ex
              
              # Update system
              yum update -y

              # Install Docker
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user

              # Install Git
              yum install -y git

              # Docker login
              echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin

              # Stop old container if running
              docker stop vulnguard-ai || true
              docker rm vulnguard-ai || true

              # Pull and run container
              docker pull ${var.docker_username}/vuln-guard-ai:latest
              docker run -d -p 80:8000 --restart unless-stopped --name vulnguard-ai ${var.docker_username}/vuln-guard-ai:latest
              EOF

  tags = {
    Name = "VulnGuardAI-Server"
  }
}

# Output the public IP of the instance
output "ec2_public_ip" {
  value = aws_instance.vgai_server.public_ip
}
