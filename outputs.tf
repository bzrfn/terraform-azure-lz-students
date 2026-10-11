output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "vm_name" {
  value = module.compute.vm_name
}

output "vm_private_ip" {
  value = module.compute.vm_private_ip
}

output "bastion_name" {
  value = module.compute.bastion_name
}

output "web_app_name" {
  value = module.app.web_app_name
}

output "web_app_url" {
  value = "https://${module.app.default_hostname}"
}

output "postgresql_fqdn" {
  value = module.data.postgresql_fqdn
}

output "storage_account_name" {
  value = module.data.storage_account_name
}

output "private_endpoint_ips" {
  value = module.data.private_endpoint_ips
}

