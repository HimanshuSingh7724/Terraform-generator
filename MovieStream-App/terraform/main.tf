provider "aws" {
  region = "us-west-1"
}

resource "aws_eks_cluster" "moviestream_cluster" {
  name     = "moviestream-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.subnet[*].id
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-moviestream-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
