
data "aws_vpc" "default" { 
  default = true
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
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
  ami           = "ami-09278528675a8d54e"   # Amazon Linux 2 AMI in eu-north-1
  instance_type = "t3.micro"
  key_name      = "private_key"             # This must match the key pair name created in AWS

  security_groups = [aws_security_group.allow_ssh_http.name]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker pull ${var.docker_image}",       # 🐳 Pull image passed from GitHub Actions
      "sudo docker run -d -p 8080:80 ${var.docker_image}"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)  # Use var from .tfvars file or CLI
      host        = self.public_ip
      timeout     = "10m"
    }
  }

  tags = {
    Name = "Flask-Docker-App"
  }
}
