locals {
  argocd_host   = "argocd.${local.kind_domain}"
  generate_cert = var.cert_manager_ca_clusterissuer_cert.cert == "" ? true : false
  gitea_host    = "gitea.${local.kind_domain}"
  kind_domain   = "${var.kind_cluster_name}.${var.kind_cluster_local_domain}"
}
