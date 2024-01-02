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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    wiz = {
      version = " ~> 1.1"
      source  = "tf.app.wiz.io/wizsec/wiz"
    }

  }
}

provider "wiz" {
  client_id = var.wiz_auth_client_id
  secret    = var.wiz_auth_client_secret

}
/*
provider "kubectl" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.default.token
  load_config_file       = false
}
*/

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
/*
provider "helm" {

  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data)
    #token                  = data.aws_eks_cluster_auth.default.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", "${var.name_prefix}-cluster"]
    }
  }

}

provider "kubernetes" {
  #apply_retry_count      = 5
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data) #  load_config_file       = false
  #token                  = data.aws_eks_cluster_auth.default.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "${var.name_prefix}-cluster"]
  }
}
*/
/*
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
*/

data "aws_eks_cluster" "default" {
  depends_on = [aws_eks_cluster.cluster]
  name       = "${var.name_prefix}-cluster"
}

data "aws_eks_cluster_auth" "default" {
  depends_on = [aws_eks_cluster.cluster]
  name       = "${var.name_prefix}-cluster"
}
