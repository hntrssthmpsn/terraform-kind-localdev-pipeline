module "pipeline" {
  source                  = "../../"
  kind_cluster_name       = "gloo-example-cluster"
  gloo_enabled            = true
  ingress_nginx_enabled   = false
  ingress_http_node_port  = 31500
  ingress_https_node_port = 32500
}
