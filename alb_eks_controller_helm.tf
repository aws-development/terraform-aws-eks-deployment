/*
resource "helm_release" "alb_controller" {
  #depends_on = [aws_eks_cluster.cluster, ]
  count      = var.alb_controller_enabled ? 1 : 0
  name       = var.alb_controller_helm_chart_name
  chart      = var.alb_controller_helm_chart_release_name
  repository = var.alb_controller_helm_chart_repo
  version    = var.alb_controller_helm_chart_version
  namespace  = var.alb_controller_namespace

  set {
    name  = "clusterName"
    value = aws_eks_cluster.cluster.name
  }

  set {
    name  = "awsRegion"
    value = var.REGION
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.alb_controller_service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.load_balancer_controller.arn
  }

  set {
    name  = "enableServiceMutatorWebhook"
    value = "false"
  }

  values = [
    yamlencode(var.alb_controller_settings)
  ]

}
*/
