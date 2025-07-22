resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket" "resized" {
  bucket = var.resized_bucket_name
}
