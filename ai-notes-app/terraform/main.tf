provider "aws" {
  region = "eu-north-1"
}

# ✅ Random ID for unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# ✅ S3 Bucket
resource "aws_s3_bucket" "voice_bucket" {
  bucket = "voice-bucket-${random_id.bucket_id.hex}"
}

# ✅ DB password variable
variable "db_password" {
  description = "The RDS database password"
  type        = string
  sensitive   = true
}

# ✅ RDS Instance
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

# ✅ ECR Repository
resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

# ✅ ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
}

# ✅ Use EXISTING ECS Execution Role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# ✅ ECS Task Definition with ENV VARS
resource "aws_ecs_task_definition" "task" {
  family                   = "ai-notes-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "ai-notes-app"
    image     = "${aws_ecr_repository.repo.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "DB_HOST"
        value = aws_db_instance.postgres_db.endpoint
      },
      {
        name  = "DB_PASSWORD"
        value = var.db_password
      },
      {
        name  = "S3_BUCKET"
        value = aws_s3_bucket.voice_bucket.bucket
      },
      {
        name  = "AWS_REGION"
        value = "eu-north-1"
      }
    ]
  }])
}

# ✅ ECS Service
resource "aws_ecs_service" "service" {
  name            = "ai-notes-app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-024aa601a4696585c"]   # ✅ Tumhara subnet
    security_groups  = ["sg-03865f37baee2fd4b"]       # ✅ Tumhara SG
    assign_public_ip = true
  }

  depends_on = [aws_ecs_cluster.cluster]
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

output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}
