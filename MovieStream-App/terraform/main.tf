provider "aws" {
  region = "us-west-1"
}

# EKS Cluster
resource "aws_eks_cluster" "moviestream_cluster" {
  name     = "moviestream-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-04d9871c9a6fe442b",  # us-west-1a
      "subnet-0f47850e35c446822"   # us-west-1c
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy
  ]
}

# IAM Role for EKS
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

# Attach EKS Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}
