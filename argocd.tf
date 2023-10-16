locals {
  argocd_host = "argocd.${var.kind_cluster_local_domain}"
}

resource "bcrypt_hash" "admin_pass" {
  cleartext = var.argocd_admin_pass
}

data "template_file" "argocd_values" {
  template = <<EOF
dex:
  enabled: false
configs:
  secret:
    argocdServerAdminPassword: ${bcrypt_hash.admin_pass.id}
  params:
    create: true
    "server.insecure": true
server:
  service:
    type: "NodePort"
  extraArgs:
    - --insecure
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: ca-issuer
      cert-manager.io/common-name: ${local.argocd_host}
    hosts:
      - ${local.argocd_host}
    tls:
      - secretName: argocd-cert
        hosts:
          - ${local.argocd_host}

  additionalApplications:
   - name: argocd-config
     namespace: argocd
     project: default
     source:
       repoURL: https://github.com/hntrssthmpsn/dummy-app.git
       targetRevision: HEAD
       path: examples/argocd/config
       directory:
         recurse: true
     destination:
       server: https://kubernetes.default.svc
     syncPolicy:
       automated:
         prune: false
         selfHeal: false
EOF
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.9.7"
  create_namespace = true

  values = ["${data.template_file.argocd_values.rendered}"]
}
