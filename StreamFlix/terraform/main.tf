provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "streamflix_sg" {
  name        = "streamflix-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "streamflix_app" {
  ami                         = "ami-09278528675a8d54e"  # Ubuntu AMI for eu-north-1
  instance_type               = "t3.micro"
  key_name                    = "my_key"
  vpc_security_group_ids      = [aws_security_group.streamflix_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo docker run -d -p 80:5000 \
                --name streamflix-app \
                ghcr.io/<himanshusingh28094>/streamflix:latest
              EOF

  tags = {
    Name = "StreamFlix"
  }
}

output "ec2_public_ip" {
  value = aws_instance.streamflix_app.public_ip
}
