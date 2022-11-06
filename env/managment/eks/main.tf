resource "awk_eks_cluster" "eks-cluster-new" {
  name = "tf-eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version = "1.22"
  tags = {
    Name = "eks-cluster-tf"
  }
  depends_on  = [
     aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
    vpc_config {
    subnet_ids = [data.terraform_remote_state.vpc.outputs.public_subnet[0], data.terraform_remote_state.vpc.outputs.public_subnet[1]]
    endpoint_public_access = true
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}