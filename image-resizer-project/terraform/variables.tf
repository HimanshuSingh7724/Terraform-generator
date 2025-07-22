variable "source_bucket_name" {}
variable "resized_bucket_name" {}
variable "lambda_ecr_image_uri" {}
variable "github_repo_full_name" {}
variable "github_branch" {
  default = "main"
}
