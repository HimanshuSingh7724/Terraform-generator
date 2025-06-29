provider "aws" {
  region = "eu-north-1"
}

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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 🟡 ARCHIVE your Python file into ZIP using archive_file data source
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/def_lambda.py"   # File is directly in the current directory
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "def_lambda.lambda_handler"     # Make sure this is the function name inside def_lambda.py
  runtime       = "python3.11"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      EXAMPLE_ENV = "value"
    }
  }
}




