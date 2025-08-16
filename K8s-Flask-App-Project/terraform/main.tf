provider "aws" {
  region = "us-west-1"
}

# ---------------- Existing EKS Cluster ----------------
data "aws_eks_cluster" "existing" {
  name = "flask-cluster"
}

data "aws_eks_cluster_auth" "existing" {
  name = data.aws_eks_cluster.existing.name
}

# ---------------- Outputs ----------------
output "cluster_name" {
  value = data.aws_eks_cluster.existing.name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.existing.endpoint
}

output "cluster_arn" {
  value = data.aws_eks_cluster.existing.arn
}
