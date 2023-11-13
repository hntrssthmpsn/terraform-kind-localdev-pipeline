# Initial Setup Steps

This document describes the initial setup of a localdev environment for use with our pipeline module. None of the steps in this document are required to run the module, but the functionality they provide is required to make full use of the module as shown in our maximal example.

## Recommended Tools

These tools provide functionality that facilitates a more production-like localdev experience.

### Set up minimal DNS for a custom localdev domain
It's often very useful to have domains other than localhost resolve to 127.0.0.1 while we're working with our cluster. This is optional, a domain can be provided by another mechanism and set with the kind_cluster_local_domain variable in terraform. For use cases where local name resolution beyond localhost isn't required, we can ignore the kind_cluster_local_domain variable and use kubectl to port-forward as necessary to reach resources in the cluster.

Here we'll set up a "stub" domain `localdev` with dnsmasq and point it to 127.0.0.1. This will allow us to use subdomains of `localdev` as ingress hosts for services in our cluster without needing to do anything tedious like manage individual /etc/hosts entries. Because the default value of `kind_cluster_local_domain` is `localdev` we will not need to take any further action to make our friendly domains work automatically.

#### Set up dnsmasq on MacOS

```
brew install dnsmasq
mkdir -p $(brew --prefix)/etc/
echo 'address=/.localdev/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
sudo brew services start dnsmasq

# Test
dig arbitrary-subdomain.localdev @127.0.0.1
```

### Set up a trusted local CA

The terraform-kind-localdev-pipeline module includes a CA ClusterIssuer for cert-manager to facilitate smooth interactions between localhost and services running within the cluster using trusted self-signed certificates. If we do not supply a certificate and key, they will be automatically generated for use by cert-manager. Any CA Certificate trusted by localhost can be supplied, or if they are omitted the generated certificate can then be trusted on localhost by whatever mechanism is preferred. In this example, we will use [mkcert](https://github.com/FiloSottile/mkcert) to easily generate and trust a local CA certificate.

#### Create a trusted local CA with mkcert on MacOS

```
brew install mkcert
mkdir -p ~/.mkcert/localdev
CAROOT=~/.mkcert/localdev mkcert --install
```
Enter your password when prompted (and prompted again). Output should look like this:
```
# Example output
# Created a new local CA 💥
# Sudo password:
# The local CA is now installed in the system trust store! ⚡️
```
This will create `rootCA-key.pem' and `rootCA.pem` at `~/.mkcert/localdev`. You can copy their contents into `ca_cert` and `ca_key` variables in a terraform.tfvars file to set the cert and private key variables for the CA ClusterIssuer, but for the sake of this ephemeral example let's just use the `-var` argument to terraform to set them at the CLI.

## Component-specific requirements

These tools are required for specific optional module components.

### kubeseal for sealed-secrets

If you want to use sealed secrets locally, you'll probably want to install kubeseal if you don't already have it. Installation instructions are provided in the [sealed-secrets README](https://github.com/bitnami-labs/sealed-secrets#kubeseal).
