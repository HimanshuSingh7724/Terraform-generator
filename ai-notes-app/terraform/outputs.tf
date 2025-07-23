output "s3_bucket_name" {
  value = aws_s3_bucket.voice_bucket.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}
