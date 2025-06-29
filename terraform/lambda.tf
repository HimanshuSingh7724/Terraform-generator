provider "aws" {
  region = "eu-north-1" # Stockholm region
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach basic execution permissions for logging
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function using existing .zip file
resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  filename         = "C:/Users/This PC/Documents/aws_lambda_function.zip"
  source_code_hash = filebase64sha256("C:/Users/This PC/Documents/aws_lambda_function.zip")

  environment {
    variables = {
      EXAMPLE_ENV = "value"
    }
  }
}


