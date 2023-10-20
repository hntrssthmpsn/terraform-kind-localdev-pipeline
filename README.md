# terraform-kind-localdev-pipeline

This Terraform code automates the setup of a local Kubernetes development environment using KIND (Kubernetes IN Docker). It sets up various services essential for a CI/CD pipeline and Kubernetes management, ensuring you have all the tools you need to start building, testing, and deploying containerized applications.

## Key Components

* KIND Cluster: Creates a local Kubernetes cluster using KIND.
* Docker Registry: Provisions a local Docker registry for storing Docker images.
* Ingress-Nginx: Sets up an Nginx ingress controller for routing traffic within the cluster.
* Cert-Manager: Manages TLS certificates and sets up a local CA (Certificate Authority).
* ArgoCD: Provisions an ArgoCD instance for GitOps-based deployments.
* Gitea: Sets up a Gitea instance for self-hosted Git services.
* Sealed Secrets: Integrates Bitnami's Sealed Secrets for managing Kubernetes secrets.


## Usage

### Gitea

To push a local repository to the gitea instance running in the local kind cluster, we need to set gitea as a remote for the local repository. We can do that with:

```
cd /path/to/repository
git remote add $REMOTE_NAME $GITEA_URL/gitea_admin/$REPO_NAME
```

Note that the in-cluster gitea instance only supports git via https with user/password authentication. Because all traffic occurs on localhost and our credentials are throwaways associated with an ephemeral gitea instance, we can simply add them to $GITEA_URL in our remote setting to avoid the need to supply them for every pull/push.

## Terraform Documentation

<!-- BEGIN_TF_DOCS -->
### Providers

| Name | Version |
|------|---------|
| <a name="provider_bcrypt"></a> [bcrypt](#provider\_bcrypt) | 0.1.2 |
| <a name="provider_docker"></a> [docker](#provider\_docker) | 3.0.2 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.2.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | terraform-iaac/cert-manager/kubernetes | n/a |

### Resources

| Name | Type |
|------|------|
| [bcrypt_hash.admin_pass](https://registry.terraform.io/providers/viktorradnai/bcrypt/0.1.2/docs/resources/hash) | resource |
| [docker_container.kind_registry](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container) | resource |
| [docker_image.kind_registry](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gitea](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.sealed_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kind_cluster.default](https://registry.terraform.io/providers/tehcyx/kind/0.2.1/docs/resources/cluster) | resource |
| [kubernetes_namespace.cert_manager_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.ca_issuer_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [tls_private_key.cert_manager_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.cert_manager_ca_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [template_file.argocd_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.cluster_issuer_yaml](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.gitea_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ingress_nginx_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.sealed_secrets_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_admin_password"></a> [argocd\_admin\_password](#input\_argocd\_admin\_password) | admin password for the cluster's argocd deployment | `string` | `"kindclusterdefaultadminpass"` | no |
| <a name="input_argocd_enabled"></a> [argocd\_enabled](#input\_argocd\_enabled) | Deploy argocd to the kind cluster? | `bool` | `false` | no |
| <a name="input_argocd_helm_chart_version"></a> [argocd\_helm\_chart\_version](#input\_argocd\_helm\_chart\_version) | The version of the argocd helm chart. | `string` | `"4.9.7"` | no |
| <a name="input_cert_manager_ca_clusterissuer_cert"></a> [cert\_manager\_ca\_clusterissuer\_cert](#input\_cert\_manager\_ca\_clusterissuer\_cert) | The PEM-formatted certificate and private key for cert-manager's CA ClusterIssuer. If left blank, a self-signed cert with a 24 hour expiry will be used. | <pre>object({<br>    cert        = string<br>    private_key = string<br>  })</pre> | <pre>{<br>  "cert": "",<br>  "private_key": ""<br>}</pre> | no |
| <a name="input_cert_manager_ca_clusterissuer_email"></a> [cert\_manager\_ca\_clusterissuer\_email](#input\_cert\_manager\_ca\_clusterissuer\_email) | The email address to use for the CA ClusterIssuer | `string` | `"admin@example.local"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The namespace for cert-manager deployment. | `string` | `"cert-manager"` | no |
| <a name="input_docker_registry_address"></a> [docker\_registry\_address](#input\_docker\_registry\_address) | The address of the docker registry, useful if using a docker registry not managed here. | `string` | `"kind-registry"` | no |
| <a name="input_docker_registry_cluster_port"></a> [docker\_registry\_cluster\_port](#input\_docker\_registry\_cluster\_port) | The port number for the docker registry on the kind cluster network. | `number` | `"5000"` | no |
| <a name="input_docker_registry_host_port"></a> [docker\_registry\_host\_port](#input\_docker\_registry\_host\_port) | The port number for the docker registry on the host, external to the kind cluster. | `number` | `"5001"` | no |
| <a name="input_gitea_admin_email"></a> [gitea\_admin\_email](#input\_gitea\_admin\_email) | The email address for gitea's admin user | `string` | `"gitea@example.boguslocaldomain"` | no |
| <a name="input_gitea_admin_password"></a> [gitea\_admin\_password](#input\_gitea\_admin\_password) | The password for gitea's admin user. | `string` | `"kindclusterdefaultadminpass"` | no |
| <a name="input_gitea_admin_username"></a> [gitea\_admin\_username](#input\_gitea\_admin\_username) | The username for gitea's admin user. | `string` | `"gitea_admin"` | no |
| <a name="input_gitea_enabled"></a> [gitea\_enabled](#input\_gitea\_enabled) | Deploy gitea to the kind cluster? | `bool` | `false` | no |
| <a name="input_gitea_helm_version"></a> [gitea\_helm\_version](#input\_gitea\_helm\_version) | Version of the gitea helm chart to use | `string` | `"9.5.0"` | no |
| <a name="input_gitea_namespace"></a> [gitea\_namespace](#input\_gitea\_namespace) | The namespace to use for gitea deployment | `string` | `"gitea"` | no |
| <a name="input_ingress_nginx_helm_version"></a> [ingress\_nginx\_helm\_version](#input\_ingress\_nginx\_helm\_version) | The ingress-nginx helm chart version. | `string` | `""` | no |
| <a name="input_ingress_nginx_http_host_port"></a> [ingress\_nginx\_http\_host\_port](#input\_ingress\_nginx\_http\_host\_port) | The host port number to use for http ingress to services exposed via ingress-nginx | `number` | `"9080"` | no |
| <a name="input_ingress_nginx_https_host_port"></a> [ingress\_nginx\_https\_host\_port](#input\_ingress\_nginx\_https\_host\_port) | The host port number to use for https ingress to services exposed via ingress-nginx | `number` | `"9443"` | no |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | The ingress-nginx namespace. | `string` | `"ingress-nginx"` | no |
| <a name="input_kind_cluster_config_path"></a> [kind\_cluster\_config\_path](#input\_kind\_cluster\_config\_path) | The file to which the cluster's kubeconfig will be saved. | `string` | `"~/.kube/config"` | no |
| <a name="input_kind_cluster_local_domain"></a> [kind\_cluster\_local\_domain](#input\_kind\_cluster\_local\_domain) | The local domain of the kind cluster. | `string` | `"localdev"` | no |
| <a name="input_kind_cluster_name"></a> [kind\_cluster\_name](#input\_kind\_cluster\_name) | The name of the kind cluster. | `string` | `"butterflies-on-toast"` | no |
| <a name="input_sealed_secrets_enabled"></a> [sealed\_secrets\_enabled](#input\_sealed\_secrets\_enabled) | Deploy sealed secrets to the kind cluster? | `string` | `false` | no |
| <a name="input_sealed_secrets_helm_version"></a> [sealed\_secrets\_helm\_version](#input\_sealed\_secrets\_helm\_version) | The sealed secrets helm chart version | `string` | `""` | no |
| <a name="input_sealed_secrets_namespace"></a> [sealed\_secrets\_namespace](#input\_sealed\_secrets\_namespace) | The sealed secrets namespace. | `string` | `"kube-system"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_address"></a> [argocd\_address](#output\_argocd\_address) | n/a |
| <a name="output_cert_manager_ca_clusterissuer_generated_cert"></a> [cert\_manager\_ca\_clusterissuer\_generated\_cert](#output\_cert\_manager\_ca\_clusterissuer\_generated\_cert) | n/a |
| <a name="output_cert_manager_ca_clusterissuer_generated_private_key"></a> [cert\_manager\_ca\_clusterissuer\_generated\_private\_key](#output\_cert\_manager\_ca\_clusterissuer\_generated\_private\_key) | n/a |
| <a name="output_gitea_address"></a> [gitea\_address](#output\_gitea\_address) | n/a |
| <a name="output_gitea_https_git_remote"></a> [gitea\_https\_git\_remote](#output\_gitea\_https\_git\_remote) | n/a |
<!-- END_TF_DOCS -->
