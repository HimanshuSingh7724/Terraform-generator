provider "aws" {
    region = "eu-north-1"
}

resource "aws_security_group" "example_sg" {
    name = "example_security_group"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = "vpc-04f2046632b609fcc"

    ingress {
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tag = {
    Name = "example_sg"
  }
}

resource "aws_instance" "my_ec2" {
    ami = "ami-042b4708b1d05f512"
    instance_type = "t3.micro"
    key_name = "my_key"

    vpc_security_group_ids = [aws_security_group.example_sg.id]

    tag = {
        Name = "MyInstanceWithSG"
    }
}

