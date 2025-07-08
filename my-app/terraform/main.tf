provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "my-unique-bucket-name-123456"
  acl    = "private"
}
