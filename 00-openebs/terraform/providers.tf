terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "/home/agarces/kubectl/shr_debian_kubeconfig"
}
