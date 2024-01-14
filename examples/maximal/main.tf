module "pipeline" {
  source                        = "../../"
  kind_cluster_name             = "maximal-example"
  kind_cluster_persistence_path = var.kind_cluster_persistence_path
  argocd_enabled                = true
  docker_registry_enabled       = true
  gitea_enabled                 = true
  sealed_secrets_enabled        = true
  gloo_enabled = true
  cert_manager_ca_clusterissuer_cert = {
    cert        = var.ca_cert
    private_key = var.ca_key
  }
}

resource "local_file" "pipeline_env_file" {
  content  = <<-EOT
    ARGOCD_ADDRESS=${module.pipeline.argocd_address}
    ARGOCD_ADMIN_PASSWORD=${module.pipeline.argocd_admin_password}
    GITEA_ADDRESS=${module.pipeline.gitea_address}
    GITEA_HTTPS_GIT_REMOTE=${module.pipeline.gitea_https_git_remote}
    GITEA_HTTP_GIT_REMOTE_INTERNAL=${module.pipeline.gitea_http_git_remote_internal}
  EOT
  filename = "${path.root}/.pipeline/pipeline.env"
}

resource "local_file" "argocd_aoa_manifest" {
  content  = <<-EOT
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: argocd-apps
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: ${module.pipeline.gitea_http_git_remote_internal}/terraform-kind-localdev-pipeline.git

        targetRevision: HEAD
        path: examples/maximal/manifests/argocd
        directory:
          recurse: true
      destination:
        server: https://kubernetes.default.svc
        namespace: argocd
      syncPolicy:
        automated:
          selfHeal: true
  EOT
  filename = "${path.root}/.pipeline/argocd-apps.yaml"
}

check "health_check" {
  data "http" "gitea_https" {
    url         = module.pipeline.gitea_https_git_remote
    ca_cert_pem = var.ca_cert
    depends_on  = [module.pipeline]
    retry {
      min_delay_ms = 500
      attempts     = 3
    }
  }

  assert {
    condition     = data.http.gitea_https.status_code == 200
    error_message = "${data.http.gitea_https.url} returned an unhealthy status code"
  }
}

