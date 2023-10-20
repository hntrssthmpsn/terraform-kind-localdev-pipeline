locals {
  argocd_host   = "argocd.${local.kind_domain}"
  docker_cluster_endpoint = "${var.docker_registry_address}:${var.docker_registry_cluster_port}"
  docker_host_endpoint    = "localhost:${var.docker_registry_host_port}"
  generate_cert = var.cert_manager_ca_clusterissuer_cert.cert == "" ? true : false
  gitea_host    = "gitea.${local.kind_domain}"
  kind_domain   = "${var.kind_cluster_name}.${var.kind_cluster_local_domain}"
}
