resource "kubernetes_deployment" "openebs-localpv-provisioner" {
  metadata {
    annotations = {
      "meta.helm.sh/release-name"      = "openebs"
      "meta.helm.sh/release-namespace" = "openebs"
    }
    labels = {
      "app"                          = "openebs"
      "app.kubernetes.io/managed-by" = "Helm"
      "chart"                        = "openebs-3.3.0"
      "component"                    = "localpv-provisioner"
      "heritage"                     = "Helm"
      "openebs.io/component-name"    = "openebs-localpv-provisioner"
      "openebs.io/version"           = "3.2.0"
      "release"                      = "openebs"
    }
    name      = "openebs-localpv-provisioner"
    namespace = kubernetes_namespace.openebs.metadata.0.name
  }
  wait_for_rollout = false
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"     = "openebs"
        "release" = "openebs"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          "app"                       = "openebs"
          "component"                 = "localpv-provisioner"
          "name"                      = "openebs-localpv-provisioner"
          "openebs.io/component-name" = "openebs-localpv-provisioner"
          "openebs.io/version"        = "3.2.0"
          "release"                   = "openebs"
        }
      }
      spec {
        container {
          args = [
            "--bd-time-out=$(BDC_BD_BIND_RETRIES)",
          ]
          image                      = "openebs/provisioner-localpv:3.2.0"
          image_pull_policy          = "IfNotPresent"
          name                       = "openebs-localpv-provisioner"
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"

          env {
            name  = "BDC_BD_BIND_RETRIES"
            value = "12"
          }
          env {
            name  = "OPENEBS_NAMESPACE"
            value = "openebs"
          }
          env {
            name = "NODE_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.nodeName"
              }
            }
          }
          env {
            name = "OPENEBS_SERVICE_ACCOUNT"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.serviceAccountName"
              }
            }
          }
          env {
            name  = "OPENEBS_IO_ENABLE_ANALYTICS"
            value = "true"
          }
          env {
            name  = "OPENEBS_IO_BASE_PATH"
            value = "/var/openebs/local"
          }
          env {
            name  = "OPENEBS_IO_HELPER_IMAGE"
            value = "openebs/linux-utils:3.2.0"
          }
          env {
            name  = "OPENEBS_IO_INSTALLER_TYPE"
            value = "charts-helm"
          }
          env {
            name  = "LEADER_ELECTION_ENABLED"
            value = "true"
          }

          liveness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 30
            period_seconds        = 60
            success_threshold     = 1
            timeout_seconds       = 1

            exec {
              command = [
                "sh",
                "-c",
                "test `pgrep -c \"^provisioner-loc.*\"` = 1",
              ]
            }
          }


          resources {
            limits   = {}
            requests = {}
          }
        }
        automount_service_account_token = false
        enable_service_links            = false
      }
    }
  }
}
resource "kubernetes_deployment" "openebs-ndm-operator" {
  metadata {
    annotations = {
      "meta.helm.sh/release-name"      = "openebs"
      "meta.helm.sh/release-namespace" = "openebs"
    }
    labels = {
      "app"                          = "openebs"
      "app.kubernetes.io/managed-by" = "Helm"
      "chart"                        = "openebs-3.3.0"
      "component"                    = "ndm-operator"
      "heritage"                     = "Helm"
      "name"                         = "ndm-operator"
      "openebs.io/component-name"    = "ndm-operator"
      "openebs.io/version"           = "3.2.0"
      "release"                      = "openebs"
    }
    name      = "openebs-ndm-operator"
    namespace = "openebs"
  }
  wait_for_rollout = false
  spec {
    replicas = "1"
    selector {
      match_labels = {
        "app"     = "openebs"
        "release" = "openebs"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        annotations = {}
        labels = {
          "app"                       = "openebs"
          "component"                 = "ndm-operator"
          "name"                      = "ndm-operator"
          "openebs.io/component-name" = "ndm-operator"
          "openebs.io/version"        = "3.2.0"
          "release"                   = "openebs"
        }
      }
      spec {
        node_selector = {}
        container {
          args                       = []
          command                    = []
          image                      = "openebs/node-disk-operator:1.9.0"
          image_pull_policy          = "IfNotPresent"
          name                       = "openebs-ndm-operator"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          env {
            name = "WATCH_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }
          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }
          env {
            name = "SERVICE_ACCOUNT"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.serviceAccountName"
              }
            }
          }
          env {
            name  = "OPERATOR_NAME"
            value = "node-disk-operator"
          }
          env {
            name  = "CLEANUP_JOB_IMAGE"
            value = "openebs/linux-utils:3.2.0"
          }

          liveness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 15
            period_seconds        = 20
            success_threshold     = 1
            timeout_seconds       = 1

            http_get {
              path   = "/healthz"
              port   = "8585"
              scheme = "HTTP"
            }
          }

          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 5
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1

            http_get {
              path   = "/readyz"
              port   = "8585"
              scheme = "HTTP"
            }
          }

          resources {
            limits   = {}
            requests = {}
          }
        }
        automount_service_account_token = false
        enable_service_links            = false
      }
    }
  }
}
