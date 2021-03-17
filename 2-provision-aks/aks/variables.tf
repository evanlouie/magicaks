variable "cluster_name" {}
variable "resource_group_name" {}
variable "location" {}

variable "k8s_subnet_id" {}
variable "user_assigned_identity_resource_id" {}
variable "log_analytics_workspace_id" {}
variable "aad_tenant_id" {}
variable "admin_group_object_ids" {}

variable "agent_count" {
    default = 1
}
