resource "kubernetes_deployment" "traefik-controller" {
  metadata {
    name      = "traefik-controller"
    namespace = kubernetes_namespace.traefik.metadata.0.name
    labels = {
      app = "traefik"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "traefik"
      }
    }
    template {
      metadata {
        labels = {
          app = "traefik"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.traefik-account.metadata.0.name
        container {
          name  = "traefik"
          image = "traefik:v2.10"
          args  = ["--api.insecure", "--providers.kubernetesingress"]
          port {
            name           = "web"
            container_port = 80
          }
          port {
            name           = "dashboard"
            container_port = 8080
          }
        }
      }
    }
  }
}
