variable "availability_zones" {
  description = "List of availability zones to be used"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_node_group_policies" {
  description = "List of IAM policy ARNs to attach to the EKS node group role"
  type        = map(string)
}

variable "eks_node_policies" {
  description = "List of IAM policy ARNs to attach to the EKS node role"
  type        = map(string)
}

variable "eks_addons" {
  description = "EKS Managed Add-ons"
  type        = map(string)
}
