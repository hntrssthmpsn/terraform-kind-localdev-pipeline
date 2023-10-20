data "template_file" "gitea_values" {
  count    = var.gitea_enabled ? 1 : 0
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
  admin:
    username: ${var.gitea_admin_username}
    password: ${var.gitea_admin_password}
    email: ${var.gitea_admin_email}
  config:
    database:
      DB_TYPE: sqlite3
    session:
      PROVIDER: memory
    cache:
      ADAPTER: memory
    queue:
      TYPE: level
    repository:
      DEFAULT_PUSH_CREATE_PRIVATE: false
      ENABLE_PUSH_CREATE_USER: true
      ENABLE_PUSH_CREATE_ORG: true

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
  count      = var.gitea_enabled ? 1 : 0
  name       = "gitea"
  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  version    = var.gitea_helm_version

  namespace        = var.gitea_namespace
  create_namespace = true

  values = ["${data.template_file.gitea_values.0.rendered}"]

  depends_on = [kind_cluster.default]
}

