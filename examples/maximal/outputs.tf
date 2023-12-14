output "argocd_address" {
  value       = module.pipeline.argocd_address
  description = "The address of argocd, if deployed."
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
