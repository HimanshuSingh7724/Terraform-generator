provider "aws" {
  region = "us-west-1"
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "my_key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/my_key.pem"
}

resource "aws_instance" "k8s_server" {
  ami           = "ami-0d9858aa3c6322f73" # Amazon Linux 2 us-west-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  tags = {
    Name = "K8s-Server"
  }
}
