# Install Gloo Edge, an Envoy-based Kubernetes ingress and API gateway.
# Gloo provides HTTP ingress into the GKE cluster for this solution.
# Gloo's advanced API gateway features allow for easy resiliency.

#  depends_on = [null_resource.local_k8s_context]

data "template_file" "gloo_values" {
  count    = var.gloo_enabled ? 1 : 0
  template = <<EOF
#gatewayProxies:
#  gatewayProxy:
#    service:
#      type: ClusterIP
#      extraAnnotations:
#        cloud.google.com/neg: '{"exposed_ports": {"80":{"name": "ingressgateway"}}}'
#    kind:
#      deployment:
#    antiAffinity: true
gatewayProxies:
  gatewayProxy:
    service:
      type: NodePort
      httpPort: 31500
      httpsPort: 32500
      httpNodePort: ${var.ingress_http_node_port}
      httpsNodePort: ${var.ingress_https_node_port}
    kind:
      deployment:
        replicas: 1
global:
  AddEnterpriseSettings: false
  extauthCustomYaml: false
EOF
}

resource "helm_release" "gloo" {
  count    = var.gloo_enabled ? 1 : 0
  name  = "gloo"

  repository       = "https://storage.googleapis.com/solo-public-helm"
  chart            = "gloo"
  namespace        = "gloo-system"
  version          = var.gloo_helm_chart_version
  create_namespace = true

  values = ["${data.template_file.gloo_values.0.rendered}"]
}

