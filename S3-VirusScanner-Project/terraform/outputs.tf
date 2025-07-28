output "s3_bucket_name" {
  value = aws_s3_bucket.upload_bucket.id
}

output "lambda_name" {
  value = aws_lambda_function.virus_scan_lambda.function_name
}

output "ec2_public_ip" {
  value = aws_instance.flask_app.public_ip
  description = "Use this IP to access the Flask uploader"
}
