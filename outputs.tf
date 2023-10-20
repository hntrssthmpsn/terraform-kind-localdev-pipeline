output "argocd_address" {
  value = var.argocd_enabled ? "https://${local.argocd_host}:${var.ingress_nginx_https_host_port}" : ""
}

output "cert_manager_ca_clusterissuer_generated_cert" {
  value = local.generate_cert ? tls_self_signed_cert.cert_manager_ca_cert.0.cert_pem : ""
}

output "cert_manager_ca_clusterissuer_generated_private_key" {
  value = local.generate_cert ? tls_private_key.cert_manager_private_key.0.private_key_pem : ""
  sensitive = true
}

output "gitea_address" {
  value = var.gitea_enabled ? "https://${local.gitea_host}:${var.ingress_nginx_https_host_port}" : ""
}

output "gitea_https_git_remote" {
  value = var.gitea_enabled ? "https://${var.gitea_admin_username}:${var.gitea_admin_password}@${local.gitea_host}:${var.ingress_nginx_https_host_port}" : ""
}

