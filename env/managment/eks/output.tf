output "eks_cluster_arn" {
  value = aws_eks_cluster.my-eks.arn
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my-eks.endpoint
}

output "eks_cluster_status" {
  value = aws_eks_cluster.my-eks.status
}

output "eks_cluster_tags" {
  value = aws_eks_cluster.my-eks.tags_all
}

output "ng_status" {
  value = aws_eks_node_group.eks-nodegroup.status
}

output "ng_config" {
  value = aws_eks_node_group.eks-nodegroup.update_config
}
