provider "aws" {
  region = "us-west-1"  # Change to your preferred AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "simple-bucket-20250628"  # MUST be globally unique!
}
