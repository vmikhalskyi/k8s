resource "aws_eks_addon" "addons" {
  for_each     = var.eks_addons

  cluster_name = var.eks_cluster_name
  addon_name   = each.value
}
