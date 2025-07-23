provider "aws" {
  region = "eu-north-1" # ✅ Aapke region ke hisaab se
}

# ✅ S3 bucket
resource "aws_s3_bucket" "voice_bucket" {
  bucket = "your-s3-bucket"
}

# ✅ RDS instance
resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "notesdb"
  username             = "postgres"
  password             = "YOUR_PASSWORD"  # TODO: tfvars ya secrets me rakho
  skip_final_snapshot  = true

  publicly_accessible  = true # dev/test ke liye
}

# ✅ ECR repository
resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

# ✅ ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
}

# ✅ Optional: Output for ECR URL
output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

# ✅ Optional: Output for RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}
