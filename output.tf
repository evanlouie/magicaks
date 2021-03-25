output "key_vault_id" {
  value = module.preprovision.key_vault_id
}

output "client_certificate" {
  value = module.provision-cluster.client_certificate
}

output "client_key" {
  value = module.provision-cluster.client_key
}

output "cluster_ca_certificate" {
  value = module.provision-cluster.cluster_ca_certificate
}

output "host" {
  value = module.provision-cluster.host
}
