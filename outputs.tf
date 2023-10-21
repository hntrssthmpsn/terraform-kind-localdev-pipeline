output "argocd_address" {
  value = var.argocd_enabled ? "https://${local.argocd_host}:${var.ingress_nginx_https_host_port}" : ""
  description = "The address of argocd, if deployed."
}

output "cert_manager_ca_clusterissuer_generated_cert" {
  value = local.generate_cert ? tls_self_signed_cert.cert_manager_ca_cert.0.cert_pem : ""
  description = "The ca certificate generated for cert-manager."
}

output "cert_manager_ca_clusterissuer_generated_private_key" {
  value     = local.generate_cert ? tls_private_key.cert_manager_private_key.0.private_key_pem : ""
  sensitive = true
  description = "The private key generated for cert-manager."
}

output "gitea_address" {
  value = var.gitea_enabled ? "https://${local.gitea_host}:${var.ingress_nginx_https_host_port}" : ""
  description = "The address of gitea, if deployed."
}

output "gitea_https_git_remote" {
  value = var.gitea_enabled ? "https://${var.gitea_admin_username}:${var.gitea_admin_password}@${local.gitea_host}:${var.ingress_nginx_https_host_port}" : ""
  description = "The gitea credentials and address formatted for use in setting remotes for local git repositories."
}

output "kind_cluster_cluster_ca_certificate" {
  value = kind_cluster.default.cluster_ca_certificate
  description = "The cluster CA certificate for the kind cluster."
}

output "kind_cluster_client_certificate" {
  value = kind_cluster.default.client_certificate
  description = "The client certificate for the kind cluster."
}

output "kind_cluster_client_key" {
  value = kind_cluster.default.client_key
  description = "The client key for the kind cluster."
}

output "kind_cluster_endpoint" {
  value = kind_cluster.default.endpoint
  description = "Kubernetes api endpoint for the kind cluster."
}

