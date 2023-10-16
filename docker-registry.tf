resource "docker_image" "kind_registry" {
  name = "registry:2.8"
}


resource "docker_container" "kind_registry" {
  name     = "kind-registry"
  image    = docker_image.kind_registry.image_id
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
