provider "helm" {
  kubernetes {
    host                   = module.pipeline.kind_cluster_endpoint
    cluster_ca_certificate = module.pipeline.kind_cluster_cluster_ca_certificate
    client_certificate     = module.pipeline.kind_cluster_client_certificate
    client_key             = module.pipeline.kind_cluster_client_key
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "kubernetes" {
  host                   = module.pipeline.kind_cluster_endpoint
  cluster_ca_certificate = module.pipeline.kind_cluster_cluster_ca_certificate
  client_certificate     = module.pipeline.kind_cluster_client_certificate
  client_key             = module.pipeline.kind_cluster_client_key
}

provider "kubectl" {
  host                   = module.pipeline.kind_cluster_endpoint
  cluster_ca_certificate = module.pipeline.kind_cluster_cluster_ca_certificate
  client_certificate     = module.pipeline.kind_cluster_client_certificate
  client_key             = module.pipeline.kind_cluster_client_key
  load_config_file       = false
}
