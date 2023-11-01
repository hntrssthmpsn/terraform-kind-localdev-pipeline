module "pipeline" {
  source = "../../"
  kind_cluster_name = "maximal-default-cluster"
  argocd_enabled = true
  docker_registry_enabled = true
  gitea_enabled = true
  sealed_secrets_enabled = true
  cert_manager_ca_clusterissuer_cert = { 
    cert = var.ca_cert
    private_key = var.ca_key
  }
}

resource "local_file" "pipeline_env_file" {
  content  = <<-EOT
    ARGOCD_ADDRESS=${module.pipeline.argocd_address}
    ARGOCD_ADMIN_PASSWORD=${module.pipeline.argocd_admin_password}
    GITEA_ADDRESS=${module.pipeline.gitea_address}
    GITEA_HTTPS_GIT_REMOTE=${module.pipeline.gitea_https_git_remote}
  EOT
  filename = "${path.root}/.pipeline/pipeline.env"
}

resource "local_file" "argocd_aoa_manifest" {
  content = <<~EOT
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: argocd-apps
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: ${module.pipeline.gitea_https_git_remote}/gitea_admin/terraform-kind-localdev-pipeline.git
        targetRevision: HEAD
        path: examples/maximal/manifests/argocd
        directory:
          recurse: true
      destination:
        server: https://kubernetes.default.svc
        namespace: argocd
  EOT
  filename = "${path.root}/.pipeline/argocd-apps.yaml"
} 

