variable "eks_cluster_name" {
  description = "Provide the name of eks cluster"
  type        = string
  default     = "tf-eks-cluster"
}

variable "eks_cluster_version" {
  description = "provide the eks cluster version"
  type        = string
  default     = "1.22"
}

variable "endpoint_private_access" {
  description = "Do you want to enable private access endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Do you want to enable private access endpoint"
  type        = bool
  default     = true
}

variable "aws_eks_iam_role" {
  description = "Name of the eks iam role"
  type        = string
  default     = "eks-cluster-tf-new"
}

variable "node_group_name" {
  description = "Provide the nodegroup name"
  type        = string
  default     = "tf-code-ng"
}

variable "instance_types" {
  description = "provide the instance type"
  type        = list(string)
  default     = ["t3.2xlarge"]
}

variable "capacity_type" {
  description = "provide the instance type like ON_DEMAND or ON_SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Provide the disk size for instance"
  type        = string
  default     = "20"
}

variable "desired_size" {
  description = "Count for desired size"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Count for min size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Count for min size"
  type        = number
  default     = 5
}

variable "max_unavailable" {
  description = "Count for maximum number of node that can be unavailable at any time"
  type        = number
  default     = 1
}

variable "ng_role_name" {
  description = "node group role arn name"
  type        = string
  default     = "eks-node-group-example"
}

variable "eks_tf_role" {
  description = "provide the name for eks assume role"
  type        = string
  default     = "eks_assumet_tf_role"
}