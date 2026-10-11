output "vm_name" {
  value = azurerm_linux_virtual_machine.worker.name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.worker.id
}

output "vm_private_ip" {
  value = azurerm_network_interface.worker.private_ip_address
}

output "principal_id" {
  value = azurerm_linux_virtual_machine.worker.identity[0].principal_id
}

output "bastion_name" {
  value = try(azapi_resource.bastion_developer[0].name, null)
}

