provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-042b4708b1d05f512"   # Amazon Linux 2 AMI (region specific)
  instance_type = "t2.micro"
  key_name      = "my_key"            # AWS EC2 key pair ka naam

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
      private_key = file("~/.ssh/private_key.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Flask-Docker-App"
  }
}
