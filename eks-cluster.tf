#####
# EKS Cluster
#####
resource "aws_eks_cluster" "cluster" {
  name = "${var.name_prefix}-cluster"

  version  = var.eks_version
  role_arn = aws_iam_role.cluster.arn

  enabled_cluster_log_types = var.eks_enabled_log_types

  vpc_config {
    subnet_ids              = module.vpc_eks.private_subnets
    security_group_ids      = var.eks_security_group_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = module.kms_eks_cluster.key_arn
    }
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.name_prefix}-cluster/cluster"
  retention_in_days = 7

  kms_key_id = module.kms_eks_cluster.key_arn
}

resource "aws_iam_role" "cluster" {
  name = "${var.name_prefix}-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.cluster_role_assume_role_policy.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"

  ]
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.REGION} update-kubeconfig --name ${aws_eks_cluster.cluster.name}"
  }
}

# adding roles to aws_auth config map

resource "kubernetes_config_map" "aws_auth" {
  #provider = kubernetes
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - rolearn: ${aws_iam_role.kubectl_ssm_role.arn}
        username: admin
        groups:
          - system:masters

      - rolearn: ${aws_iam_role.kubectl_ssm_role.arn}
        username: developer
        groups:
          - system:bootstrappers
          - system:nodes

      - rolearn: ${aws_iam_role.kubectl_ssm_role.arn}
        username: devops
        groups:
          - system:bootstrappers
          - system:nodes
          - deployment:write

    EOT
  }
}





#####
# Outputs
#####
output "eks_id" {
  value       = aws_eks_cluster.cluster.id
  description = "EKS cluster name."
}

output "eks_arn" {
  value       = aws_eks_cluster.cluster.arn
  description = "EKS cluster ARN."
}

output "eks_network_config" {
  value       = aws_eks_cluster.cluster.kubernetes_network_config
  description = "EKS cluster network configuration."
}
