resource "azurerm_storage_account" "main" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  blob_properties {
    versioning_enabled = false
    delete_retention_policy {
      days = 7
    }
  }
}

# Management-plane container creation works even while public data-plane
# access is disabled. Shared-key support remains enabled for AzureRM refresh,
# but no account key is exposed or stored in this repository.
resource "azapi_resource" "blob_container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01"
  name      = "app-data"
  parent_id = "${azurerm_storage_account.main.id}/blobServices/default"

  body = {
    properties = {
      publicAccess = "None"
    }
  }
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.postgresql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16"
  administrator_login    = var.postgresql_admin_username
  administrator_password = var.postgresql_admin_password
  sku_name               = var.postgresql_sku
  storage_mb             = 32768
  backup_retention_days  = 7
  geo_redundant_backup_enabled = false
  public_network_access_enabled = false
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }

  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = true
    tenant_id                     = var.tenant_id
  }
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "current_user" {
  server_name         = azurerm_postgresql_flexible_server.main.name
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  object_id           = var.entra_admin_object_id
  principal_name      = var.entra_admin_principal_name
  principal_type      = "User"
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "link-postgresql-vnet"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-blob-vnet"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "postgresql" {
  name                          = "pe-postgresql-${var.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.db_subnet_id
  custom_network_interface_name = "nic-pe-postgresql-${var.suffix}"
  tags                          = var.tags

  private_service_connection {
    name                           = "psc-postgresql"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  ip_configuration {
    name               = "ipconfig-postgresql"
    private_ip_address = "10.0.2.4"
    subresource_name   = "postgresqlServer"
    member_name        = "postgresqlServer"
  }

  private_dns_zone_group {
    name                 = "pdzg-postgresql"
    private_dns_zone_ids = [azurerm_private_dns_zone.postgresql.id]
  }
}

resource "azurerm_private_endpoint" "blob" {
  name                          = "pe-blob-${var.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.endpoints_subnet_id
  custom_network_interface_name = "nic-pe-blob-${var.suffix}"
  tags                          = var.tags

  private_service_connection {
    name                           = "psc-blob"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  ip_configuration {
    name               = "ipconfig-blob"
    private_ip_address = "10.0.4.4"
    subresource_name   = "blob"
    member_name        = "blob"
  }

  private_dns_zone_group {
    name                 = "pdzg-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}

