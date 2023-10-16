locals {
  generate_cert = var.cert_manager_ca_clusterissuer_private_key == "" || var.cert_manager_ca_clusterissuer_cert == "" ? true : false
  namespace     = kubernetes_namespace.cert_manager_namespace.metadata[0].name
}

resource "tls_private_key" "cert_manager_private_key" {
  count = local.generate_cert ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "tls_self_signed_cert" "cert_manager_ca_cert" {
  count = local.generate_cert ? 1 : 0

  is_ca_certificate = true
  private_key_pem   = tls_private_key.cert_manager_private_key.0.private_key_pem

  subject {
    common_name  = "${var.kind_cluster_name}.local"
    organization = var.kind_cluster_name
  }

  validity_period_hours = 24

  allowed_uses = [
    "cert_signing",
  ]
}

resource "local_file" "cert_manager_ca_cert" {
  count    = local.generate_cert ? 1 : 0
  content  = tls_self_signed_cert.cert_manager_ca_cert.0.cert_pem
  filename = "${path.root}/.ssl/rootCA.pem"
}

resource "kubernetes_namespace" "cert_manager_namespace" {
  metadata {
    annotations = {
      name = "${var.cert_manager_namespace}"
    }

    name = var.cert_manager_namespace
  }
}

resource "kubernetes_secret" "ca_issuer_secret" {

  metadata {
    name      = "ca-issuer-secret"
    namespace = local.namespace
  }

  data = {
    "tls.key" = local.generate_cert ? tls_private_key.cert_manager_private_key.0.private_key_pem : var.cert_manager_ca_clusterissuer_private_key
    "tls.crt" = local.generate_cert ? tls_self_signed_cert.cert_manager_ca_cert.0.cert_pem : var.cert_manager_ca_clusterissuer_cert
  }

  type = "kubernetes.io/tls"
}

data "template_file" "cluster_issuer_yaml" {
  template = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer
spec:
  ca:
    secretName: ca-issuer-secret
EOF
}

module "cert_manager" {
  source               = "terraform-iaac/cert-manager/kubernetes"
  namespace_name       = local.namespace
  create_namespace     = false
  cluster_issuer_email = var.cert_manager_ca_clusterissuer_email
  cluster_issuer_yaml  = data.template_file.cluster_issuer_yaml.rendered
}

