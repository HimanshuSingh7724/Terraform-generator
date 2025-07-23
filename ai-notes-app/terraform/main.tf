provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "voice_bucket" {
  bucket = "your-s3-bucket"
}

resource "aws_rds_instance" "postgres_db" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  name                 = "notesdb"
  username             = "postgres"
  password             = "YOUR_PASSWORD"
  skip_final_snapshot  = true
}

resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
}

# Add ECS service, task definition, IAM roles, VPC config as needed.
