provider "aws" {
  region = "us-west-1"
}

# ---------------- EKS Cluster ----------------
resource "aws_eks_cluster" "my_cluster" {
  name     = "flask-cluster"
  role_arn = "arn:aws:iam::038462747266:role/eksClusterRole"

  vpc_config {
    subnet_ids = [
      "subnet-04d9871c9a6fe442b",
      "subnet-0f47850e35c446822"
    ]
  }

  # Optional: skip creation if cluster already exists in state
  lifecycle {
    prevent_destroy = true
  }
}

# ---------------- Outputs ----------------
output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.my_cluster.arn
}
