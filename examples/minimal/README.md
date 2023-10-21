# Minimal Example

This example provisions a KIND cluster with ingress-nginx and cert-manager deployed. The default config file at ~/.kube/config is updated to add the KIND cluster credentials, so following terraform apply, you can interact with the cluster directly via kubectl.

```
# Start in this directory
cd examples/minimal

# Apply this terraform
terraform init
terraform apply

# Check provisioned resources with kubectl
kubectl get node
kubectl get all -A
