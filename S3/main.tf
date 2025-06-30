provider "aws" {
  region = "eu-north-1"
}

# Private Bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-private-bucket-unique-123456"  # globally unique name
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

# Public Bucket with website hosting
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-bucket-unique-123456"  # globally unique name

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_acl" "public_bucket_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowPublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "arn:aws:s3:::${aws_s3_bucket.public_bucket.bucket}/*"
      }
    ]
  })
}
