output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  value = {
    app       = azurerm_subnet.app.id
    db        = azurerm_subnet.db.id
    vm        = azurerm_subnet.vm.id
    endpoints = azurerm_subnet.endpoints.id
    bastion   = azurerm_subnet.bastion.id
  }
}

