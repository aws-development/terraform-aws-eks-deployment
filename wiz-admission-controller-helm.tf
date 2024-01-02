
resource "helm_release" "wiz_k8_admission_controller" {
  #depends_on       = [aws_eks_cluster.cluster]
  count            = var.wiz_install_k8_admission_controller ? 1 : 0
  name             = var.wiz_k8_admission_controller_helm_chart_name
  chart            = var.wiz_k8_admission_controller_helm_chart_release_name
  repository       = var.wiz_k8_admission_controller_helm_chart_repo
  version          = var.wiz_k8_admission_controller_helm_chart_version
  namespace        = var.wiz_namespace
  create_namespace = true
  force_update     = true
  recreate_pods    = true


  set {
    name  = "wizApiToken.clientId"
    value = var.wiz_k8_admission_controller_sa_secret_id
  }

  set_sensitive {
    name  = "wizApiToken.clientToken"
    value = var.wiz_k8_admission_controller_sa_secret_key
  }

  set {
    name  = "wizApiToken.secret.create"
    value = true
  }

  set {
    name  = "wizApiToken.secret.name"
    value = var.wiz_k8_admission_controller_sa_name
  }

  set {
    name  = "webhook.errorEnforcementMethod"
    value = "AUDIT"
  }


  set {
    name  = "webhook.policyEnforcementMethod"
    value = "AUDIT"
  }


}
