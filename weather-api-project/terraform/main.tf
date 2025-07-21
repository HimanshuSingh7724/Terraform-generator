# terraform/main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = var.my_key

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 80:5000 \
                -e WEATHER_API_KEY=${var.weather_api_key} \
                your-dockerhub/weather-app
              EOF

  tags = {
    Name = "WeatherAppServer"
  }
}
