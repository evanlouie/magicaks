terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.51.0"
    }
    github = {
      source = "hashicorp/github"
      version = "=4.5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    key = "magicaksconsolidated"
  }
}

provider "kubernetes" {
  host                   = module.provision-cluster.host
  client_key             = base64decode(module.provision-cluster.client_key)
  client_certificate     = base64decode(module.provision-cluster.client_certificate)
  cluster_ca_certificate = base64decode(module.provision-cluster.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.provision-cluster.host
    client_key             = base64decode(module.provision-cluster.client_key)
    client_certificate     = base64decode(module.provision-cluster.client_certificate)
    cluster_ca_certificate = base64decode(module.provision-cluster.cluster_ca_certificate)
  }
}

provider "github" {
  token         = var.github_pat
  organization  = var.github_user
}

data "azurerm_subscription" "current" {
}

module "preprovision" {
  source              = "./1-preprovision"
  location            = var.location
  resource_group_name = var.resource_group_name
  resource_suffix     = var.resource_suffix
  tenant_id           = data.azurerm_subscription.current.tenant_id
}

resource "null_resource" "buildgrafana" {
  provisioner "local-exec" {
    command = "./utils/grafana/buildonacr.sh ${module.preprovision.acr_name} ${var.grafana_image_name}"
  }
}

data "azurerm_user_assigned_identity" "magicaksmsi" {
  name                = var.cluster_msi_name
  resource_group_name = var.resource_group_name
}

# Create cluster only after a suitable delay
resource "time_sleep" "preprovision" {
  create_duration = "60s"

  triggers = {
    acr_name  = module.preprovision.acr_name
  }
}

module "provision-cluster" {
  providers    = { azurerm = azurerm }
  source              = "./2-provision-aks"
  cluster_name        = var.cluster_name
  subscription_id     = data.azurerm_subscription.current.id
  aad_tenant_id       = var.aad_tenant_id
  admin_group_object_ids = var.admin_group_object_ids
  k8s_subnet_id          = module.preprovision.k8s_subnet_id
  aci_subnet_id          = module.preprovision.aci_subnet_id
  aci_network_profile_id = module.preprovision.aci_network_profile_id
  acr_name               = time_sleep.preprovision.triggers["acr_name"]
  key_vault_id           = module.preprovision.key_vault_id
  grafana_admin_password = var.grafana_admin_password
  cluster_support_db_admin_password = var.cluster_support_db_admin_password
  grafana_image_name                = var.grafana_image_name
  monitoring_reader_sp_client_id    = var.monitoring_reader_sp_client_id
  monitoring_reader_sp_client_secret = var.monitoring_reader_sp_client_secret
  user_assigned_identity_resource_id = data.azurerm_user_assigned_identity.magicaksmsi.id
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  depends_on = [ module.preprovision ]
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [module.provision-cluster]

  create_duration = "60s"
}

# module "postprovision" {
#   providers    = { kubernetes = kubernetes, helm = helm }
#   source = "./3-postprovision"
#   cluster_name = var.cluster_name
#   location = var.location
#   github_pat = var.github_pat
#   github_user = var.github_user
#   k8s_manifest_repo = var.k8s_manifest_repo
#   k8s_workload_repo = var.k8s_workload_repo
#   key_vault_id = module.preprovision.key_vault_id
#   app_name = var.app_name

#   depends_on = [time_sleep.wait_60_seconds, module.provision-cluster]
# }