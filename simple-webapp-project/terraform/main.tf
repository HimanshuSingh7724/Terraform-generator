provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH access from anywhere (you can restrict to your IP)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c2b8ca1dad447f8a"  # ✅ Updated working Amazon Linux 2 AMI for eu-north-1
  instance_type = "t3.micro"
  key_name      = "my_key"                # ✅ Make sure this key exists in AWS Console

  security_groups = [aws_security_group.allow_ssh_http.name]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "docker run -d -p 80:80 himanshusingh28094/flask-app"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.private_key        # 🔐 From GitHub secret
      host        = self.public_ip
    }

    timeout = "10m"
  }

  tags = {
    Name = "Flask-Docker-App"
  }
}
