resource "kubernetes_namespace" "openebs" {
  metadata {
    labels = {
      name = "openebs"
    }
  }
}
