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
data "aws_subnet_ids" "selected" {
  vpc_id = "vpc-05e4357eda2a99ad0"  # aapka existing VPC
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = data.aws_subnet_ids.selected.ids
  }
}
