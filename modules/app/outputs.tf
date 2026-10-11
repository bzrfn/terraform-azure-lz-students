output "web_app_name" {
  value = azurerm_linux_web_app.main.name
}

output "web_app_id" {
  value = azurerm_linux_web_app.main.id
}

output "default_hostname" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "principal_id" {
  value = azurerm_linux_web_app.main.identity[0].principal_id
}

