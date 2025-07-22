output "source_bucket_name" {
  value = aws_s3_bucket.source.id
}

output "resized_bucket_name" {
  value = aws_s3_bucket.resized.id
}
