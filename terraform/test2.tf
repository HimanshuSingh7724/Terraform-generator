resource "aws_s3_bucket" "example" {
  bucket = "your-unique-bucket-name-xyz123"
  # acl removed
  tags = {
    Name        = "MyExampleBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}
