data "kubectl_file_documents" "metallb-ipaddr-config" {
  content = file("metallb-ipaddress-config.yaml")
}

resource "kubectl_manifest" "metallb-ipaddr-config" {
  for_each  = data.kubectl_file_documents.metallb-ipaddr-config.manifests
  yaml_body = each.value
}

