resource "aws_lambda_function" "image_resizer" {
  function_name = "image-resizer"
  image_uri     = var.ecr_image_uri
  package_type  = "Image"
  role          = var.lambda_role_arn

  environment {
    variables = {
      RESIZED_BUCKET = var.resized_bucket
    }
  }
}
