resource "aws_iam_user" "eks_developer_user" {
    name = "developer"
}

data "aws_iam_policy_document" "eks_developer_policy" {
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]

    resources = ["*"]  
  }
}

resource "aws_iam_user_policy" "eks_user_policy" {
  name   = "eks-user-policy"
  user   = aws_iam_user.eks_developer_user.name
  policy = data.aws_iam_policy_document.eks_developer_policy.json
}

resource "aws_eks_access_entry" "developer" {
    cluster_name = var.eks_cluster_name
    principal_arn = aws_iam_user.eks_developer_user.arn
    kubernetes_groups = ["viewer-group"]
}