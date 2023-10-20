data "template_file" "sealed_secrets_values" {
  count    = var.sealed_secrets_enabled ? 1 : 0
  template = <<EOF
fullnameOverride: "sealed-secrets-controller"
EOF
}

resource "helm_release" "sealed_secrets" {
  count      = var.sealed_secrets_enabled ? 1 : 0
  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = var.sealed_secrets_helm_version

  namespace        = var.sealed_secrets_namespace
  create_namespace = true

  values = ["${data.template_file.sealed_secrets_values.0.rendered}"]

  depends_on = [kind_cluster.default]
}

