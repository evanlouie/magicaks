output "cluster_object_id" {
    value = azurerm_kubernetes_cluster.k8s_cluster.kubelet_identity.0.object_id
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.host
}