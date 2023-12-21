terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }

  }
}

provider "aws" {
  region     = var.REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  default_tags {
    tags = {
      Environment = "dev"
      Team        = "Ravikumar"
      Repository  = "https://github.com/aws-development/terraform-aws-eks-deployment"
      Service     = "eks"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.name_prefix]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = aws_eks_cluster.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.cluster_id]
  }
}
