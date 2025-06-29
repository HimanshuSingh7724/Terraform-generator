resource "aws_iam_role" "lambda_exec_role" {
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
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

resource "aws_lambda_function" "example_lambda" {
    function_name = "example_lambda"
    role          = aws_iam_role.lambda_exec_role.arn
    handler       = "index.handler"
    runtime       = "python3.11"

    filename         = "lambda_function_payload.zip"
    source_code_hash = filebase64sha256("lambda_function_payload.zip")

    environment {
        variables = {
            EXAMPLE_ENV = "value"
        }
    }
}