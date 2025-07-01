provider "aws" {
  region = "eu-north-1"
}

# Modified SG name to avoid "already exists" error
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg_tf"  # changed name 
  description = "Allow HTTP to ALB and outbound to instances"
  vpc_id      = "vpc-04f2046632b609fcc"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg_tf"
  description = "Allow traffic from ALB"
  vpc_id      = aws_security_group.alb_sg.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_instances" {
  count         = 2
  ami           = "ami-042b4708b1d05f512"
  instance_type = "t3.micro"
  key_name      = "my_key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-instance-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "Hello from instance ${count.index + 1}" > /var/www/html/index.html
              EOF
}

resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0609d48d7653438b5", "subnet-024aa601a4696585c"]  # Replace with valid subnets in your VPC
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_security_group.alb_sg.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_instances[count.index].id
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
