provider "aws" {
  region = "eu-north-1" # ✅ Aapka AWS region
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
  password             = var.db_password  # ✅ Secure
  skip_final_snapshot  = true

  publicly_accessible  = true # Dev/Test ke liye theek hai
}

# ✅ ECR repository
resource "aws_ecr_repository" "repo" {
  name = "ai-notes-app"
}

# ✅ ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ai-notes-cluster"
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
