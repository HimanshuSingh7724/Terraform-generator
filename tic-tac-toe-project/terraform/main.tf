provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "tic_tac_toe" {
  ami           = "ami-09278528675a8d54e" # Amazon Linux 2 in eu-north-1
  instance_type = "t3.micro"
  key_name      = var.key_name

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

output "public_ip" {
  value = aws_instance.tic_tac_toe.public_ip
}
