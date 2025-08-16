provider "aws" {
  region = "us-west-1"
}

# ---------------- IAM Role ----------------
resource "aws_iam_role" "eks_role" {
  name = "eksClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Attach EKS Managed Policy
resource "aws_iam_role_policy_attachment" "eks_role_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------- EKS Cluster ----------------
resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-04d9871c9a6fe442b", 
      "subnet-0f47850e35c446822"
    ]
  }
}
