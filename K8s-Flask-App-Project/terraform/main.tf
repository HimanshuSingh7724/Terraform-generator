provider "aws" {
  region = "us-west-1"
}

# ---------------- Existing IAM Role use karna ----------------
data "aws_iam_role" "eks_role" {
  name = "eksClusterRole"   # Pehle se exist kar raha role
}

# ---------------- EKS Cluster ----------------
resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"
  role_arn = data.aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = ["subnet-12345", "subnet-67890"]
  }
}

# ---------------- Agar aap naya role create karna chahte ho to comment kar dein ----------------
# resource "aws_iam_role" "eks_role" {
#   name = "eksClusterRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action    = "sts:AssumeRole"
#       Effect    = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#     }]
#   })
# }
