provider "aws" {
  region = var.aws_region
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  identifier           = var.db_name          # <-- yahan name ki jagah identifier use kiya
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
