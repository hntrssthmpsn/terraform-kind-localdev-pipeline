resource "kind_cluster" "default" {
  name            = var.kind_cluster_name
  kubeconfig_path = pathexpand("${var.kind_cluster_config_path}")
  wait_for_ready  = true
  depends_on      = [local_file.hosts_toml]

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    containerd_config_patches = [
      <<-TOML
        [plugins."io.containerd.grpc.v1.cri".registry]
            config_path = "/etc/containerd/certs.d"
        TOML
    ]

    # control-plane node
    node {
      role = "control-plane"
      # Mount generated config for docker
      extra_mounts {
        host_path      = local.kind_docker_config_path
        container_path = "/etc/containerd/certs.d"
      }
    }

    # worker node with labels for ingress-nginx
    node {
      role = "worker"
      labels = {
        ingress-ready = "true"
      }

      # http port mappings 
      extra_port_mappings {
        container_port = var.ingress_http_node_port
        host_port      = var.ingress_http_host_port
      }

      # https port mappings 
      extra_port_mappings {
        container_port = var.ingress_https_node_port
        host_port      = var.ingress_https_host_port
      }

      # Mount local directory for persistent storage
      extra_mounts {
        host_path      = local.kind_persistence_path
        container_path = "/var/local-path-provisioner"
      }
      # Mount generated config for docker
      extra_mounts {
        host_path      = local.kind_docker_config_path
        container_path = "/etc/containerd/certs.d"
      }
      # Mount any additional user-specified mounts
      dynamic "extra_mounts" {
        for_each = var.kind_cluster_worker_extra_mounts
        content {
          host_path      = extra_mounts.value["host_path"]
          container_path = extra_mounts.value["container_path"]
        }
      }
    }
  }
}

resource "local_file" "hosts_toml" {
  content  = <<-EOT
    [host."http://${local.docker_cluster_endpoint}"]
  EOT
  filename = "${local.kind_docker_config_path}/${local.docker_host_endpoint}/hosts.toml"
}
