provider "aws" {
  region = "us-west-1"
}

# ---------------- Use Existing IAM Role ----------------
data "aws_iam_role" "eks_role" {
  name = "eksClusterRole"   # Existing IAM role
}

# ---------------- EKS Cluster ----------------
resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"
  role_arn = data.aws_iam_role.eks_role.arn

  vpc_config {
    # Directly specify your existing subnet ID
    subnet_ids = ["subnet-04d9871c9a6fe442b"]
  }
}

# Optional output for cluster name
output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}
