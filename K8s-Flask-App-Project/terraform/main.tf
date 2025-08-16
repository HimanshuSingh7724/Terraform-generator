provider "aws" {
  region = "us-west-1"
}

# ---------------- EKS Cluster ----------------
resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"

  # Existing IAM Role ARN
  role_arn = "arn:aws:iam::038462747266:role/eksClusterRole"

  vpc_config {
    subnet_ids = [
      "subnet-04d9871c9a6fe442b", 
      "subnet-0f47850e35c446822"
    ]
  }
}

# ---------------- Outputs ----------------
output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}
