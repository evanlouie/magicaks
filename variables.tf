variable "resource_group_name" {
  description = "Resource group to deploy your cluster to"
  type        = string
}
variable "location" {
  description = "Azure data-center location (e.g \"westus2\")"
  type        = string
}
variable "resource_suffix" {
  description = "Suffix for names of resources provisioend via MagicAKS"
  type        = string
}
variable "cluster_name" {
  description = "Name of AKS cluster to be provisioned"
  type        = string
}
variable "cluster_msi_name" {
  type = string
}

variable "aad_tenant_id" {
  description = "AAD Tenant ID"
  type        = string
}
variable "admin_group_object_ids" {
  type = list(string)
}

variable "cluster_support_db_admin_password" {
  type = string
}

variable "grafana_image_name" {
  type    = string
  default = "grafana:v1"
}
variable "grafana_admin_password" {
  type = string
}

variable "monitoring_reader_sp_client_id" {
  type = string
}
variable "monitoring_reader_sp_client_secret" {
  type = string
}

variable "github_pat" {
  type = string
}
variable "github_user" {
  type = string
}

variable "k8s_manifest_repo" {
  type = string
}
variable "k8s_workload_repo" {
  type = string
}
variable "app_name" {
  type = string
}
