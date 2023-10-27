resource "kubernetes_cluster_role_binding" "traefik-role-binding" {
  metadata {
    name = "traefik-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.traefik-role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "traefik-account"
    namespace = kubernetes_namespace.traefik.metadata.0.name
  }
}
