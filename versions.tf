# versions.tf

terraform {
  required_providers {
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = "0.1.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=3.0.2"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }

  required_version = ">= 1.5.7"
}
