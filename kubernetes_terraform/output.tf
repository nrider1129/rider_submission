output "endpoint" {
  value = "${module.eks_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${module.eks_cluster.kubeconfig-certificate-authority-data}"
}