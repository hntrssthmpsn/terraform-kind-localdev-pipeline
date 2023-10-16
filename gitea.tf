locals {
  gitea_host = "gitea.${var.kind_cluster_local_domain}"
}

data "template_file" "gitea_values" {
  template = <<EOF
redis-cluster:
  enabled: false
postgresql:
  enabled: false
postgresql-ha:
  enabled: false

persistence:
  enabled: false

gitea:
  config:
    database:
      DB_TYPE: sqlite3
    session:
      PROVIDER: memory
    cache:
      ADAPTER: memory
    queue:
      TYPE: level

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
    cert-manager.io/common-name: ${local.gitea_host}
  hosts:
    - host: ${local.gitea_host}
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: gitea-cert
      hosts:
        - ${local.gitea_host}

EOF
}

resource "helm_release" "gitea" {
  name       = "gitea"
  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  version    = var.gitea_helm_version

  namespace        = var.gitea_namespace
  create_namespace = true

  values = ["${data.template_file.gitea_values.rendered}"]

  depends_on = [kind_cluster.default]
}

