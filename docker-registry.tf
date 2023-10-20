resource "docker_image" "kind_registry" {
  count = var.docker_registry_enabled ? 1 : 0
  name  = "registry:${var.docker_registry_image_tag}"
}


resource "docker_container" "kind_registry" {
  count    = var.docker_registry_enabled ? 1 : 0
  name     = "kind-registry"
  image    = docker_image.kind_registry.0.image_id
  must_run = true
  restart  = "always"
  networks_advanced {
    name = "kind"
  }
  ports {
    internal = "5000"
    external = var.docker_registry_host_port
  }
  depends_on = [kind_cluster.default]
}
