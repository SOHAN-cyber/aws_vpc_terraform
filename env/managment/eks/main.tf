resource "aws_eks_cluster" "my-eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.assume_eks.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids              = [data.terraform_remote_state.vpc.outputs.public_subnet[0], data.terraform_remote_state.vpc.outputs.public_subnet[1]]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }
  tags = {
    "Name" = var.eks_cluster_name
  }
}
resource "aws_iam_role" "assume_eks" {
  name = var.aws_eks_iam_role

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
  role       = aws_iam_role.assume_eks.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.assume_eks.name
}

data "tls_certificate" "tf-eks-oidc" {
  url = aws_eks_cluster.my-eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc-eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.tf-eks-oidc.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.tf-eks-oidc.url
}

data "aws_iam_policy_document" "tf_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc-eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc-eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_tf_role" {
  assume_role_policy = data.aws_iam_policy_document.tf_assume_role_policy.json
  name               = var.eks_tf_role
}


resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name    = aws_eks_cluster.my-eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.ng.arn
  subnet_ids      = [data.terraform_remote_state.vpc.outputs.public_subnet[0], data.terraform_remote_state.vpc.outputs.public_subnet[1]]
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  update_config {
    max_unavailable = var.max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "ng" {
  name = var.ng_role_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ng.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ng.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ng.name
}