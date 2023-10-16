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

variable "argocd_admin_pass" {
  type        = string
  description = "admin password for the cluster's argocd deployment"
  default     = ""
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
  type        = string
  description = "The PEM-formatted certificate for cert-manager's CA ClusterIssuer. Leave empty to auto-generate"
  default     = ""
}

variable "cert_manager_ca_clusterissuer_email" {
  type        = string
  description = "The email address to use for the CA ClusterIssuer"
  default     = "admin@example.local"
}

variable "cert_manager_ca_clusterissuer_private_key" {
  type        = string
  description = "The private key for cert-manager's CA ClusterIssuer. Leave empty to auto-generate."
  default     = ""
}

###############################
# Docker Registry Configuration
###############################

variable "docker_registry_address" {
  type        = string
  description = "The address of the docker registry, useful if using a docker registry not managed here."
  default     = "kind-registry"
}

variable "docker_registry_host_port" {
  type        = number
  description = "The port number for the docker registry on the host, external to the kind cluster."
  default     = "5001"
}

variable "docker_registry_cluster_port" {
  type        = number
  description = "The port number for the docker registry on the kind cluster network."
  default     = "5000"
}

######################
# Gitea Configuration
######################

variable "gitea_namespace" {
  type        = string
  description = "The namespace to use for gitea deployment"
  default     = "gitea"
}

variable "gitea_helm_version" {
  type        = string
  description = "Version of the gitea helm chart to use"
  default     = "9.5.0"
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
