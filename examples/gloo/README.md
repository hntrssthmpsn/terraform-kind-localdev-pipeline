# Gloo Example

This example provisions a KIND cluster with the [Gloo Edge API Gateway](https://docs.solo.io/gloo-edge/latest/) deployed. In addition to kind and terraform, it assumes you've got [glooctl](https://docs.solo.io/gloo-edge/latest/getting_started/) installed locally.

Start in this directory
```bash
cd examples/gloo
```

Apply this terraform
```bash
terraform init
terraform apply
```

Run and expose an nginx pod
```bash
kubectl run --image=nginx nginx
kubectl expose po nginx --port=80 --name=nginx
```

Confirm an Upstream resource was created for our nginx service
```bash
glooctl get upstream default-nginx-80
```

Add a route to our nginx upstream
```bash
glooctl add route \
  --path-exact /jibberjabber \
  --dest-name default-nginx-80 \
  --prefix-rewrite /
```

The nginx default page should now be available at http://localhost:9080/jibberjabber
