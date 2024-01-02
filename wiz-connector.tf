
# Remove this if the namespace already exists
resource "kubernetes_namespace" "wiz_namespace" {
  metadata {
    name = var.wiz_namespace
  }
}

resource "kubernetes_cluster_role" "wiz_cluster_reader" {
  metadata {
    name = "wiz-cluster-reader"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["*"]
    resources  = ["*"]
  }
}

resource "kubernetes_service_account" "wiz_cluster_reader" {
  metadata {
    name      = "wiz-cluster-reader"
    namespace = var.wiz_namespace
  }
}

resource "kubernetes_secret" "wiz_cluster_reader_token" {
  metadata {
    name      = "wiz-cluster-reader-token"
    namespace = var.wiz_namespace

    annotations = {
      "kubernetes.io/service-account.name" = "wiz-cluster-reader"
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [kubernetes_service_account.wiz_cluster_reader]
}


resource "kubernetes_cluster_role_binding" "wiz_cluster_reader" {
  metadata {
    name = "wiz-cluster-reader"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "wiz-cluster-reader"
    namespace = var.wiz_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "wiz-cluster-reader"
  }
}
resource "time_sleep" "wait_5_seconds_for_token_generation" {
  depends_on = [kubernetes_secret.wiz_cluster_reader_token]

  create_duration = "5s"
}

data "kubernetes_secret" "service_account_token" {
  metadata {
    name      = kubernetes_secret.wiz_cluster_reader_token.metadata[0].name
    namespace = var.wiz_namespace
  }
  depends_on = [time_sleep.wait_5_seconds_for_token_generation]
}

resource "wiz_kubernetes_connector" "connector" {
  depends_on                   = [aws_eks_cluster.cluster]
  name                         = var.wiz_connector_name
  service_account_token        = data.kubernetes_secret.service_account_token.data.token
  server_certificate_authority = base64encode(data.kubernetes_secret.service_account_token.data["ca.crt"])
  server_endpoint              = var.wiz_server_endpoint
  connector_type               = var.wiz_connector_type
  enabled                      = true
  is_private_cluster           = var.wiz_is_private
}





resource "time_sleep" "wait_2_minutes_for_connector_creation" {
  depends_on = [wiz_kubernetes_connector.connector]

  create_duration = "2m"
}

data "wiz_tunnel_server" "tunnel_domain" {}

resource "kubernetes_secret" "wiz_broker_config" {
  metadata {
    name      = format("wiz-broker-%s-config", wiz_kubernetes_connector.connector.id)
    namespace = var.wiz_namespace
  }
  type = "Opaque"

  data = {
    "WIZ_CLIENT_ID" : var.wiz_broker_client_id
    "WIZ_CLIENT_TOKEN" : var.wiz_broker_client_secret
    "WIZ_ENV" : var.wiz_env
    "CONNECTOR_ID" : wiz_kubernetes_connector.connector.id
    "CONNECTOR_TOKEN" : wiz_kubernetes_connector.connector.tunnel_token
    "TARGET_DOMAIN" : wiz_kubernetes_connector.connector.tunnel_domain
    "TARGET_IP" : wiz_kubernetes_connector.connector.broker_host
    "TARGET_PORT" : wiz_kubernetes_connector.connector.broker_port
    "TUNNEL_SERVER_ADDR" : data.wiz_tunnel_server.tunnel_domain.domain
    "TUNNEL_SERVER_PORT" : data.wiz_tunnel_server.tunnel_domain.port
    "DISABLE_CUSTOM_TLS_FIRST_BYTE" : "true"
  }
}

resource "kubernetes_service_account" "wiz_broker" {
  metadata {
    name      = "wiz-broker"
    namespace = var.wiz_namespace
  }
}

resource "kubernetes_deployment" "wiz_broker" {
  depends_on = [time_sleep.wait_2_minutes_for_connector_creation]
  metadata {
    name      = "wiz-broker"
    namespace = var.wiz_namespace

    labels = {
      app = "wiz-broker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wiz-broker"
      }
    }

    template {
      metadata {
        labels = {
          app = "wiz-broker"
        }
      }

      spec {
        container {
          name  = "wiz-broker"
          image = var.wiz_image_path

          env_from {
            secret_ref {
              name = kubernetes_secret.wiz_broker_config.metadata[0].name
            }
          }

          security_context {
            run_as_non_root            = true
            run_as_user                = 1000
            allow_privilege_escalation = false
          }
        }
        service_account_name = kubernetes_service_account.wiz_broker.metadata[0].name
      }
    }
  }
}
