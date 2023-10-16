data "template_file" "sealed_secrets_values" {
  template = <<EOF
fullnameOverride: "sealed-secrets-controller"
EOF
}

resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = var.sealed_secrets_helm_version

  namespace        = var.sealed_secrets_namespace
  create_namespace = true

  values = ["${data.template_file.sealed_secrets_values.rendered}"]

  depends_on = [kind_cluster.default]
}

