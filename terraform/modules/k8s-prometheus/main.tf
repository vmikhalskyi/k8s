data "aws_iam_policy_document" "ebs_csi_driver" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "aws_ebc_csi_driver_role" {
  name               = "${var.cluster_name}-aws-ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver.json
}

resource "aws_iam_role_policy_attachment" "aws_ebc_csi_driver_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.aws_ebc_csi_driver_role.name
}

resource "aws_eks_pod_identity_association" "aws_ebs_csi_driver" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = "ebs-csi-controller-sa"
    role_arn = aws_iam_role.aws_ebc_csi_driver_role.arn
}

resource "helm_release" "prometheus_server" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "prometheus"
  version = "25.27.0"
  create_namespace = true

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }
}