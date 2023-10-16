data "template_file" "ingress_nginx_values" {
  template = <<EOF
controller:
  hostPort:
    enabled: true
  terminationGracePeriodSeconds: 0
  service:
    type: "NodePort"
  watchIngressWithoutClass: true
  nodeSelector:
    ingress-ready: "true"
  publishService:
    enabled: false
  extraArgs:
    publish-status-address: "localhost"
EOF
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_helm_version

  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  values = ["${data.template_file.ingress_nginx_values.rendered}"]

  depends_on = [kind_cluster.default]
}

