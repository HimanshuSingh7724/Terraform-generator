provider "aws" {
    region = "eu-north-1"
}

resource "aws_s3_bucket" "private_bucket" {
    bucket = "my-private-bucket-unique-123456" 
    acl = "private"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-bucket-unique-123456"   # globally unique name
  acl    = "public-read"

  website {
    index_document = "index.html"

  } 

    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowPublicRead",
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject"],
      Resource  = "arn:aws:s3:::${aws_s3_bucket.public_bucket.bucket}/*"
    }]
  })
}
