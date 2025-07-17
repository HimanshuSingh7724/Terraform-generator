

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket-123456"
  acl    = "private"

  tags = {
    Name        = "MyExampleBucket"
    Environment = "Dev"
  }
}
