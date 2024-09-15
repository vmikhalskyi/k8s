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