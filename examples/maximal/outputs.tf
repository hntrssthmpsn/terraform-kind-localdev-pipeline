output "argocd_address" {
  value       = module.pipeline.argocd_address
  description = "The address of argocd, if deployed."
}

output "cert_manager_ca_clusterissuer_generated_cert" {
  value       = module.pipeline.cert_manager_ca_clusterissuer_generated_cert
  description = "The ca certificate generated for cert-manager."
}

output "cert_manager_ca_clusterissuer_generated_private_key" {
  value       = module.pipeline.cert_manager_ca_clusterissuer_generated_private_key
  sensitive   = true
  description = "The private key generated for cert-manager."
}

output "gitea_address" {
  value       = module.pipeline.gitea_address
  description = "The address of gitea, if deployed."
}

output "gitea_https_git_remote" {
  value       = module.pipeline.gitea_https_git_remote
  description = "The gitea credentials and address formatted for use in setting remotes for local git repositories."
}

output "gitea_http_git_remote_internal" {
  value       = module.pipeline.gitea_http_git_remote_internal
  description = "The gitea credentials and address formatted for use in setting remotes for local-to-the-cluster git repositories"
}
