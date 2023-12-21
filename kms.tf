resource "aws_kms_key" "aws_eks_kms_key" {
  description             = "KMS key for EKS encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = merge(tomap({ "Name" = join("-", [local.env, local.project, "eks-kms-key"]) }), tomap({ "ResourceType" = "KMS" }), local.common_tags, )
}
