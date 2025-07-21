provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "sg" {
  name = "urlshort-sg"
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

resource "aws_instance" "app" {
  ami           = "ami-09278528675a8d54e" # Amazon Linux 2
  instance_type = "t3.micro"
  key_name      = var.my_key

  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install docker -y
              service docker start
              docker run -d -p 80:5000 ${var.docker_image}
              EOF

  tags = {
    Name = "url-shortener"
  }
}

output "url" {
  value = "http://${aws_instance.app.public_ip}"
}
