provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  name   = "http-ssh-group"
  vpc_id = data.aws_vpc.default.id

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

resource "aws_instance" "web" {
  ami               = "ami-09278528675a8d54e"
  instance_type     = "t3.micro"
  key_name          = var.key_name
  security_groups   = [aws_security_group.sg.name]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo docker pull ${var.docker_image}",
      "sudo docker run -d -p 80:80 ${var.docker_image}"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.private_key_content
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Flask-Todo-App"
  }
}

output "web_ip" {
  value = aws_instance.web.public_ip
}
