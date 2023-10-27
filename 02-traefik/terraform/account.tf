resource "kubernetes_service_account" "traefik-account" {
  metadata {
    name      = "traefik-account"
    namespace = kubernetes_namespace.traefik.metadata.0.name
  }
}
