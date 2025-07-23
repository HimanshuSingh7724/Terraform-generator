output "s3_bucket_name" {
  value = aws_s3_bucket.voice_bucket.bucket
}

output "db_endpoint" {
  value = aws_rds_instance.postgres_db.endpoint
}
