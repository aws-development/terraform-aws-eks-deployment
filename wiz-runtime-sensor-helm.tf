/*
resource "helm_release" "wiz_runtime_sensor" {
  #depends_on       = [aws_eks_cluster.cluster]
  count            = var.wiz_install_runtime_sensor ? 1 : 0
  name             = var.wiz_runtime_sensor_helm_chart_name
  chart            = var.wiz_runtime_sensor_helm_chart_release_name
  repository       = var.wiz_runtime_sensor_helm_chart_repo
  version          = var.wiz_runtime_sensor_helm_chart_version
  namespace        = var.wiz_namespace
  create_namespace = true
  force_update     = true
  recreate_pods    = true

  set {
    name  = "imagePullSecret.username"
    value = var.wiz_registry_username
  }

  set_sensitive {
    name  = "imagePullSecret.password"
    value = var.wiz_registry_password
  }

  set {
    name  = "wizApiToken.clientId"
    value = var.wiz_runtime_sensor_sa_secret_id
  }

  set_sensitive {
    name  = "wizApiToken.clientToken"
    value = var.wiz_runtime_sensor_sa_secret_key
  }
}
*/
