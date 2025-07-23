provider "aws" {
  region = "eu-north-1"
}

# ✅ Random ID generator for unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# ✅ S3 bucket with unique name
resource "aws_s3_bucket" "voice_bucket" {
  bucket = "voice-bucket-${random_id.bucket_id.hex}"
}

# ✅ Variable for DB password
variable "db_password" {
  description = "The RDS database password"
  type        = string
  sensitive   = true
}

# ✅ RDS instance
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

# ✅ ECR repository
resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

# ✅ ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
}

# ✅ Use EXISTING IAM Role instead of creating new one
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# ✅ ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = "ai-notes-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ai-notes-app"
      image     = "${aws_ecr_repository.repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ✅ Outputs
output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.voice_bucket.bucket
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}

output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}
