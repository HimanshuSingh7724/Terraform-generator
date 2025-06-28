provider "aws" {
  region = "us-west-1"  # Or use your actual configured region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-super-unique-bucket-jun28-2025"  # Replace with a unique name

  tags = {
    Name        = "MyTerraformBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}

