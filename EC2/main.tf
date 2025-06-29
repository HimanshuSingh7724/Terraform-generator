terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Create EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-042b4708b1d05f512" # Ubuntu 22.04 AMI in eu-north-1
  instance_type = "t3.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

# Create a CloudWatch Alarm for high CPU
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilizationAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers when CPU utilization is above 70% for 10 minutes"
  actions_enabled     = false

  dimensions = {
    InstanceId = aws_instance.my_ec2.id
  }

  tags = {
    Environment = "Dev"
  }
}
