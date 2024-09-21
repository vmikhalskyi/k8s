variable "availability_zones" {
  description = "List of availability zones to be used"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] 
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"] 
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "mikhalskyi-cluster-sample"
}

variable "eks_node_group_policies" {
  description = "List of IAM policy ARNs to attach to the EKS node group role"
  type        = map(string)
  default     = {
    eks_worker_node_policy     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    eks_cni_policy             = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    eks_ec2_container_policy   = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

variable "eks_node_policies" {
  description = "List of IAM policy ARNs to attach to the EKS node role"
  type        = map(string)
  default     = {
    eks_worker_node_policy     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    eks_cni_policy             = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    eks_ec2_container_policy   = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

variable "eks_addons" {
  description = "EKS Managed Add-ons"
  type        = map(string)
  default     = {
    "coredns"                   = "coredns"
    "kube-proxy"                = "kube-proxy"
    "vpc-cni"                   = "vpc-cni"
    "eks-pod-identity-webhook"  = "eks-pod-identity-agent"
    "aws-ebs-csi-driver"        = "aws-ebs-csi-driver"
  }
}

variable git_source_path {
  description = "ArgoCD Root App path to applications folder"
  type = string
  default = "argocd/dev/applications"
}

variable git_source_repo_url {
  description = "GitHub Repo URL for ArgoCD"
  type = string
  default = "git@github.com:vmikhalskyi/k8s.git"
}

variable git_source_target_revision {
  description = "ArgoCD defaul target revision"
  type = string
  default = "HEAD"
}