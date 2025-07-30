provider "aws" {
  region = "eu-north-1"
}

# Create a Security Group to allow SSH (22) and HTTP (80)
resource "aws_security_group" "ocr_app_sg" {
  name        = "ocr-app-sg"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP for security
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ocr-app-sg"
  }
}

# Create IAM Role for EC2 (e.g., to access S3 if needed)
resource "aws_iam_role" "ocr_ec2_role" {
  name = "ocr-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# Attach Policy to allow EC2 to access S3 and CloudWatch Logs
resource "aws_iam_role_policy_attachment" "ocr_s3_access" {
  role       = aws_iam_role.ocr_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ocr_cloudwatch_access" {
  role       = aws_iam_role.ocr_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create Instance Profile to attach the role to EC2
resource "aws_iam_instance_profile" "ocr_instance_profile" {
  name = "ocr-instance-profile"
  role = aws_iam_role.ocr_ec2_role.name
}

# EC2 Instance
resource "aws_instance" "ocr_app" {
  ami                    = "ami-09278528675a8d54e" # Ubuntu Server
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ocr_app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ocr_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              docker run -d -p 80:5000 himanshu/ocr-extractor
              EOF

  tags = {
    Name = "OCRAppServer"
  }
}
