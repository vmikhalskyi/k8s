terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Env = var.env
      terraform = "true"
    }
    
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.example.token
  }
}


