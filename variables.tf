# variables.tf


#############################
# Kind Cluster Configuration 
#############################

variable "kind_cluster_name" {
  type        = string
  description = "The name of the kind cluster."
  default     = "butterflies-on-toast"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "The file to which the cluster's kubeconfig will be saved."
  default     = "~/.kube/config"
}

variable "kind_cluster_local_domain" {
  type        = string
  description = "The local domain of the kind cluster."
  default     = "localdev"
}

#######################
# ArgoCD Configuration
#######################

variable "argocd_enabled" {
  type        = bool
  description = "Deploy argocd to the kind cluster?"
  default     = false
}

variable "argocd_admin_password" {
  type        = string
  description = "admin password for the cluster's argocd deployment"
  default     = "kindclusterdefaultadminpass"
}

variable "argocd_helm_chart_version" {
  type        = string
  description = "The version of the argocd helm chart."
  default     = "4.9.7"
}

##############################
# Cert-Manager Configuration
##############################

variable "cert_manager_namespace" {
  type        = string
  description = "The namespace for cert-manager deployment."
  default     = "cert-manager"
}

variable "cert_manager_ca_clusterissuer_cert" {
  type = object({
    cert        = string
    private_key = string
  })
  description = "The PEM-formatted certificate and private key for cert-manager's CA ClusterIssuer. If left blank, a self-signed cert with a 24 hour expiry will be used."
  default = {
    cert        = ""
    private_key = ""
  }
  validation {
    condition     = (var.cert_manager_ca_clusterissuer_cert.cert == "") == (var.cert_manager_ca_clusterissuer_cert.private_key == "")
    error_message = "Please supply both cert_manager_ca_clusterissuer_cert.cert and cert_manager_ca_clusterissuer_cert.private_key or, to autocreate, supply neither. Supplying either without the other is not supported."
  }
}

variable "cert_manager_ca_clusterissuer_email" {
  type        = string
  description = "The email address to use for the CA ClusterIssuer"
  default     = "admin@example.local"
}

###############################
# Docker Registry Configuration
###############################

variable "docker_registry_enabled" {
  type        = bool
  description = "Deploy a local docker registry with docker?"
  default     = false
}

variable "docker_registry_address" {
  type        = string
  description = "The address of the docker registry, useful if using a docker registry not managed here."
  default     = "kind-registry"
}

variable "docker_registry_cluster_port" {
  type        = number
  description = "The port number for the docker registry on the kind cluster network."
  default     = "5000"
}

variable "docker_registry_host_port" {
  type        = number
  description = "The port number for the docker registry on the host, external to the kind cluster."
  default     = "5001"
}

variable "docker_registry_image_tag" {
  type        = string
  description = "The image tag/version to use for our docker-registry"
  default     = "2.8"
}

######################
# Gitea Configuration
######################

variable "gitea_enabled" {
  type        = bool
  description = "Deploy gitea to the kind cluster?"
  default     = false
}

variable "gitea_admin_email" {
  type        = string
  description = "The email address for gitea's admin user"
  default     = "gitea@example.boguslocaldomain"
}

variable "gitea_admin_password" {
  type        = string
  description = "The password for gitea's admin user."
  default     = "kindclusterdefaultadminpass"
}

variable "gitea_admin_username" {
  type        = string
  description = "The username for gitea's admin user."
  default     = "gitea_admin"
}

variable "gitea_helm_version" {
  type        = string
  description = "Version of the gitea helm chart to use"
  default     = "9.5.0"
}

variable "gitea_namespace" {
  type        = string
  description = "The namespace to use for gitea deployment"
  default     = "gitea"
}

##############################
# Ingress Nginx Configuration
##############################

variable "ingress_nginx_helm_version" {
  type        = string
  description = "The ingress-nginx helm chart version."
  default     = ""
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "The ingress-nginx namespace."
  default     = "ingress-nginx"
}

variable "ingress_nginx_http_host_port" {
  type        = number
  description = "The host port number to use for http ingress to services exposed via ingress-nginx"
  default     = "9080"
}

variable "ingress_nginx_https_host_port" {
  type        = number
  description = "The host port number to use for https ingress to services exposed via ingress-nginx"
  default     = "9443"
}

###############################
# Sealed Secrets Configuration
###############################

variable "sealed_secrets_enabled" {
  type        = string
  description = "Deploy sealed secrets to the kind cluster?"
  default     = false
}

variable "sealed_secrets_helm_version" {
  type        = string
  description = "The sealed secrets helm chart version"
  default     = ""
}

variable "sealed_secrets_namespace" {
  type        = string
  description = "The sealed secrets namespace."
  default     = "kube-system"
}
