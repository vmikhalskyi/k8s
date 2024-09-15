data "aws_iam_policy_document" "eks_node_group_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_node_role" {
  name               = "eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policies_attachment" {
  for_each = var.eks_node_group_policies

  policy_arn = each.value
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "sample-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnets_ids

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  capacity_type = "SPOT"
  instance_types = ["t3.medium"] 

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}