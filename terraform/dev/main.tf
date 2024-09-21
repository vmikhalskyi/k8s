data "aws_eks_cluster" "example" {
  name = module.k8s-cluster.eks_cluster_endpoint.name
  depends_on = [ module.k8s-cluster ]
}

data "aws_eks_cluster_auth" "example" {
  name = data.aws_eks_cluster.example.name
  depends_on = [ module.k8s-cluster ]
}

module "network" {
    source = "../modules/network"
    availability_zones = var.availability_zones
    public_subnets = var.public_subnets
}

module "k8s-cluster" {
    source = "../modules/k8s-cluster"
    cluster_name = var.cluster_name
    public_subnets_ids = module.network.public_subnet_ids
}

module "k8s-node-group" {
    source = "../modules/k8s-node-group"
    public_subnets_ids = module.network.public_subnet_ids
    eks_cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
    eks_node_group_policies = var.eks_node_group_policies
    depends_on = [ module.k8s-cluster ]
}

module "k8s-sample-group" {
    source = "../modules/k8s-sample-group"
    eks_cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
}

module "k8s-addons" {
    source = "../modules/k8s-addons"
    eks_cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
    eks_addons = var.eks_addons
    depends_on = [ module.k8s-cluster, module.k8s-node-group ]
}

module "argocd-initial" {
    source = "../modules/argocd-initial"
    chart_version = "5.46.2"
    eks_cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
    depends_on = [ module.k8s-cluster ]
}

module "argocd-root" {
    source = "../modules/argocd-root"
    git_source_path = var.git_source_path
    git_source_repo_url = var.git_source_repo_url
    git_source_target_revision = var.git_source_target_revision
    depends_on = [ module.k8s-cluster, module.argocd-initial ]
}

# module "k8s-metrics-server" {
#     source = "../modules/k8s-metrics-server"
#     depends_on = [ module.k8s-node-group ]
# }

module "k8s-cluster-autoscaler" {
    source = "../modules/k8s-cluster-autoscaler"
    cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
    depends_on = [ module.k8s-node-group ]
}

module "k8s-aws-lb-controller" {
    source = "../modules/k8s-aws-lb-controller"
    cluster_name = module.k8s-cluster.eks_cluster_endpoint.name
    vpc_id = module.network.vpc.id
    depends_on = [ module.k8s-node-group ]
}