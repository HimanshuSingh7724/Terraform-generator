provider "aws" {
  region = "eu-north-1"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach AWSLambdaBasicExecutionRole policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Zip the Python function (def_lambda.py)
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/python/def_lambda.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

# Create the Lambda function
resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "def_lambda.lambda_handler"      # Python file name = def_lambda.py
  runtime       = "python3.11"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      EXAMPLE_ENV = "value"
    }
  }
}



