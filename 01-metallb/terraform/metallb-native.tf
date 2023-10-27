data "kubectl_file_documents" "metallb-native-install" {
  content = file("metallb-native.yaml")
}

resource "kubectl_manifest" "metallb-native-install" {
  for_each  = data.kubectl_file_documents.metallb-native-install.manifests
  yaml_body = each.value
}
