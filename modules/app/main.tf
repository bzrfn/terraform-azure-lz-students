resource "azurerm_service_plan" "main" {
  name                = "asp-${var.name_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                      = var.web_app_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = azurerm_service_plan.main.id
  https_only                = true
  public_network_access_enabled = true
  virtual_network_subnet_id = var.app_subnet_id
  tags                      = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on              = false
    ftps_state             = "Disabled"
    minimum_tls_version    = "1.2"
    vnet_route_all_enabled = true

    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    "POSTGRES_HOST"                = var.postgresql_fqdn
    "POSTGRES_PORT"                = "5432"
    "POSTGRES_DATABASE"            = "appdb"
    "POSTGRES_SSL_MODE"            = "require"
    "STORAGE_BLOB_ENDPOINT"        = var.storage_blob_url
    "STORAGE_AUTHENTICATION_MODE" = "ManagedIdentity"
  }
}

