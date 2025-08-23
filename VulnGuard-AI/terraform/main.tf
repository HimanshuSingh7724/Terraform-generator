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
  ami                    = "ami-0fa3a4915333e2850" # Amazon Linux 2 in us-west-1
  instance_type           = "t2.micro"
  key_name                = var.key_name
  vpc_security_group_ids  = [aws_security_group.vgai_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable docker
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Docker Login
              echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin

              # Pull and Run Container
              docker pull vuln-guard-ai:latest
              docker run -d -p 80:8000 --restart unless-stopped --name vulnguard-ai vuln-guard-ai:latest
              EOF

  tags = {
    Name = "VulnGuardAI-Server"
  }
}
