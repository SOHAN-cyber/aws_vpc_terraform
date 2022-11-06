output "endpoint" {
  value = aws_eks_cluster.eks-cluster-new.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-cluster-new.certificate_authority[0].data
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks-cluster-new.id
}

output "eks_cluster_arn" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks-cluster-new.arn
} 