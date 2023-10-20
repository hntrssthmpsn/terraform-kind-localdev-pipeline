resource "bcrypt_hash" "admin_pass" {
  count     = var.argocd_enabled ? 1 : 0
  cleartext = var.argocd_admin_password
}

data "template_file" "argocd_values" {
  count    = var.argocd_enabled ? 1 : 0
  template = <<EOF
dex:
  enabled: false
configs:
  secret:
    argocdServerAdminPassword: ${bcrypt_hash.admin_pass.0.id}
  params:
    create: true
    "server.insecure": true
server:
  service:
    type: "NodePort"
  extraArgs:
    - --insecure
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: ca-issuer
      cert-manager.io/common-name: ${local.argocd_host}
    hosts:
      - ${local.argocd_host}
    tls:
      - secretName: argocd-cert
        hosts:
          - ${local.argocd_host}
EOF
}

resource "helm_release" "argocd" {
  count = var.argocd_enabled ? 1 : 0
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = var.argocd_helm_chart_version
  create_namespace = true

  values = ["${data.template_file.argocd_values.0.rendered}"]
}
