output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_blob_url" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}

output "private_endpoint_ips" {
  value = {
    postgresql = azurerm_private_endpoint.postgresql.private_service_connection[0].private_ip_address
    blob       = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
  }
}

