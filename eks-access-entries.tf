#####
# EKS Access Entries
#
# EKS 1.35 deprecates the aws-auth ConfigMap. IAM principals that need
# Kubernetes API access are declared here as aws_eks_access_entry resources
# and mapped to cluster-level permissions via access policies.
#####

# The kubectl/bastion EC2 role needs cluster-admin-equivalent access.
resource "aws_eks_access_entry" "kubectl_ssm" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.kubectl_ssm_role.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "kubectl_ssm_admin" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.kubectl_ssm_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.kubectl_ssm]
}

# Node-group IAM role - use EC2_LINUX type so EKS auto-grants the node
# permissions (equivalent to the old system:bootstrappers/system:nodes mapping).
resource "aws_eks_access_entry" "managed_node_group" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.eks_node_group.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "karpenter_node" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.eks_node_karpenter.arn
  type          = "EC2_LINUX"
}

