provider "aws" {
    region = "eu-north-1"
}

resource "aws_iam_user" "dev_user" {
    name = "developer_user"
}

resource "aws_iam_group" "dev_group" { 
    name = "developer"
}

resource "aws_iam_user_group_membership" "dev_membership" {
    user = aws_iam_user.dev_user.name
    group = [aws_iam_group.dev_group.name]
}

resource "aws_iam_policy" "s3_read_only" {
    name = "S3ReadOnlyAccess"
    description = "Allow read-only access to s3"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action   = ["s3:Get*", "s3:List*"],
            Effect   = "Allow",
            Resource = "*"
    }]
  })
}
resource "aws_iam_policy_attachment" "attach_s3_read_to_group" {
  name       = "AttachS3ReadPolicy"
  policy_arn = aws_iam_policy.s3_read_only.arn
  groups     = [aws_iam_group.dev_group.name]
}
resource "aws_iam_policy" "boundary_policy" {
  name = "BoundaryPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "LimitPermissions",
      Effect = "Allow",
      Action = "*",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "dev_role" {
  name = "DeveloperRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  permissions_boundary = aws_iam_policy.boundary_policy.arn
}

