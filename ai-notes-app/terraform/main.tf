provider "aws" {
  region = "eu-north-1"
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "voice_bucket" {
  bucket = "voice-bucket-${random_id.bucket_id.hex}"
}

variable "db_password" {
  description = "The RDS database password"
  type        = string
  sensitive   = true
}

resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "notesdb"
  username             = "postgres"
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true
}

resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.voice_bucket.bucket
}

output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}
