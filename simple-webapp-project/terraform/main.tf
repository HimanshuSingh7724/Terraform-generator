provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-09278528675a8d54e"   # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "my_key"                 # EC2 key pair (already created in AWS)

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
      private_key = var.private_key         # 🔑 GitHub Secret se milega
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Flask-Docker-App"
  }
}
