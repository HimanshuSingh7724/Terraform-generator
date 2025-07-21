provider "aws" {
  region = "eu-north-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Create security group to allow HTTP traffic
resource "aws_security_group" "weather_sg" {
  name        = "weather-sg"
  description = "Allow HTTP traffic on port 80"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP from anywhere"
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

# EC2 instance to run weather app
resource "aws_instance" "web" {
  ami           = "ami-09278528675a8d54e" # Amazon Linux 2 (Make sure it's valid for eu-north-1)
  instance_type = "t3.micro"
  key_name      = var.my_key

  vpc_security_group_ids = [aws_security_group.weather_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 80:5000 \
                -e WEATHER_API_KEY=${var.weather_api_key} \
                ${var.docker_image}
              EOF

  tags = {
    Name = "WeatherAppServer"
  }
}

# Output EC2 public IP
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "app_url" {
  value = "http://${aws_instance.web.public_ip}"
}
