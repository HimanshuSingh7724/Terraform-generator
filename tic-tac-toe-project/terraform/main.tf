provider "aws" {
  region = "eu-north-1"
}

variable "key_name" {
  default = "my_key"   
}

resource "aws_security_group" "tic_tac_toe_sg" {
  name        = "tic-tac-toe-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH access
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tic_tac_toe" {
  ami             = "ami-09278528675a8d54e" # Amazon Linux 2 (eu-north-1)
  instance_type   = "t3.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.tic_tac_toe_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p 80:5000 himanshu/tictactoe:latest
              EOF

  tags = {
    Name = "TicTacToeServer"
  }
}

# ✅ Correct output name for GitHub Actions
output "ec2_public_ip" {
  value = aws_instance.tic_tac_toe.public_ip
}
