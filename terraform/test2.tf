provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-super-unique-bucket-jun28-2025"

  tags = {
    Name        = "MyTerraformBucket"
    Environment = "Dev"
  }
}


