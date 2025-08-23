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
  ami           = "ami-0945610b37068d87a"
  instance_type = "t2.micro"
  key_name      = "my_key"

  # Attach Security Group
  vpc_security_group_ids = [aws_security_group.vgai_sg.id]

  # Docker install + VulnGuard-AI container run
  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Install Docker
              amazon-linux-extras install docker -y
              service docker start
              systemctl enable docker

              # Add ec2-user to docker group
              usermod -a -G docker ec2-user

              # Pull your VulnGuard-AI Docker image
              docker pull vuln-guard-ai

              # Run container mapping EC2 port 80 to container port 8000
              docker run -d -p 80:8000 --restart unless-stopped --name vulnguard-ai vuln-guard-ai
              EOF

  tags = {
    Name = "VulnGuardAI-Server"
  }
}
