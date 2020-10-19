output "endpoint" {
  value = aws_eks_cluster.eks_test_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_test_cluster.certificate_authority[0].data
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_test_cluster.name
}