provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  key_name      = "my_key"

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "AzurePipelineMigrationInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              EOF
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
