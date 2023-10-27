resource "kubernetes_service" "traefik-lb" {
  metadata {
    name      = "traefik-lb"
    namespace = kubernetes_namespace.traefik.metadata.0.name
  }
  spec {
    selector = {
      app : kubernetes_deployment.traefik-controller.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = 443
    }
    port {
      name        = "dashboard"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
    }
  }
}
