provider "rancher2" {
  api_url  = "https://your-rancher-url.com/v3"
  token_key = "your-rancher-api-token"
  token_secret = "your-rancher-api-secret"
}

# Define Kubernetes resources for ArgoCD
resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_service_account" "argocd_service_account" {
  metadata {
    name      = "argocd-service-account"
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding" "argocd_cluster_role_binding" {
  metadata {
    name = "argocd-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_service_account.metadata.0.name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }
}

resource "kubernetes_deployment" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }
  spec {
    selector {
      match_labels = {
        app = "argocd-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "argocd-server"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.argocd_service_account.metadata.0.name
        containers {
          name  = "argocd-server"
          image = "argoproj/argocd:v2.1.0"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}



