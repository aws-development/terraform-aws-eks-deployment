resource "aws_eks_cluster" "eks" {
  name = local.eks_cluster_name
  vpc_config {
    subnet_ids              = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id, aws_subnet.private-subnet-1c.id]
    security_group_ids      = [aws_security_group.eks-cluster-sg.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler", ]
  role_arn                  = aws_iam_role.eks-cluster-role.arn
  version                   = local.k8_version
  #tags                      = merge(merge(map("Name", "${local.env}-${local.project}-eks-cluster"),map("ResourceType", "EKS"),),local.common_tags)

  #tags                      = tomap(merge(map("Name", join("-", [local.env, local.project, "eks-cluster"])), map("ResourceType", "EKS"), local.common_tags))
  tags = merge(tomap({ "Name" = join("-", [local.env, local.project, "eks-cluster"]) }), tomap({ "ResourceType" = "EKS" }), local.common_tags, )

  encryption_config {
    provider {
      key_arn = aws_kms_key.aws_eks_kms_key.arn
    }
    resources = ["secrets"]
  }
}

resource "aws_eks_addon" "eks_addons" {
  for_each = var.eks_addons

  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = each.key
  addon_version = each.value
}


resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = local.eks_node_group_name
  node_role_arn   = aws_iam_role.eks-worker-role.arn
  subnet_ids      = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id, aws_subnet.private-subnet-1c.id]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  tags = merge(tomap({ "Name" = join("-", [local.env, local.project, "eks-cluster-ng"]) }), tomap({ "ResourceType" = "EKS-NODE-GROUP" }), local.common_tags, )


}
