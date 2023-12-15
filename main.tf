resource "kind_cluster" "default" {
  name            = var.kind_cluster_name
  kubeconfig_path = pathexpand("${var.kind_cluster_config_path}")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    containerd_config_patches = [
      <<-TOML
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."${local.docker_host_endpoint}"]
            endpoint = ["${local.docker_cluster_endpoint}"]
        TOML
    ]

    # control-plane node
    node {
      role = "control-plane"
    }

    # worker node with labels for ingress-nginx
    node {
      role = "worker"
      labels = {
        ingress-ready = "true"
      }

      # http port mappings for ingress-nginx
      extra_port_mappings {
        container_port = 80
        host_port      = var.ingress_nginx_http_host_port
      }

      # https port mappings for ingress-nginx
      extra_port_mappings {
        container_port = 443
        host_port      = var.ingress_nginx_https_host_port
      }

      # Mount local directory for persistent storage
      extra_mounts {
        host_path      = local.kind_persistence_path
        container_path = "/var/local-path-provisioner"
      }
    }
  }
}

