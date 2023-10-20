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

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_address"></a> [argocd\_address](#output\_argocd\_address) | n/a |
| <a name="output_cert_manager_ca_clusterissuer_generated_cert"></a> [cert\_manager\_ca\_clusterissuer\_generated\_cert](#output\_cert\_manager\_ca\_clusterissuer\_generated\_cert) | n/a |
| <a name="output_cert_manager_ca_clusterissuer_generated_private_key"></a> [cert\_manager\_ca\_clusterissuer\_generated\_private\_key](#output\_cert\_manager\_ca\_clusterissuer\_generated\_private\_key) | n/a |
| <a name="output_gitea_address"></a> [gitea\_address](#output\_gitea\_address) | n/a |
| <a name="output_gitea_https_git_remote"></a> [gitea\_https\_git\_remote](#output\_gitea\_https\_git\_remote) | n/a |
<!-- END_TF_DOCS -->
