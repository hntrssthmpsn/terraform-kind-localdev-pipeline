variable "ca_cert" {
  type        = string
  description = "Add a trusted local CA cert here, or leave blank to autogenerate a cert. Note that key and cert should be supplied together."
  default     = ""
}

variable "ca_key" {
  type = string
  description = "Add the private key for a trusted local CA cert here, or leave blank to autogenerate a key. Note that key and cert should be supplied together."
  default = ""
}

variable "kind_cluster_local_domain" {
  type        = string
  description = "The local domain of the kind cluster."
  default     = "localdev"
}
