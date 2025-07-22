provider "aws" {
  region = var.aws_region
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "taskdb-subnet-group"
  subnet_ids = var.db_subnet_ids  # Yeh list aapko .tfvars me deni hai

  tags = {
    Name = "taskdb-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  identifier           = var.db_name
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
