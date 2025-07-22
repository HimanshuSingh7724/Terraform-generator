provider "aws" {
  region = "eu-north-1"
}

data "aws_caller_identity" "current" {}

module "s3" {
  source = "./s3"
  source_bucket_name  = var.source_bucket_name
  resized_bucket_name = var.resized_bucket_name
}

module "iam" {
  source = "./iam"
  github_repo_full_name = var.github_repo_full_name
  github_branch         = var.github_branch
}

module "lambda" {
  source         = "./lambda"
  source_bucket  = module.s3.source_bucket_name
  resized_bucket = module.s3.resized_bucket_name
  lambda_role_arn = module.iam.lambda_execution_role_arn
  ecr_image_uri   = var.lambda_ecr_image_uri
}
