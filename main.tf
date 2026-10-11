resource "azurerm_resource_group" "main" {
  name     = local.resource_group
  location = var.resource_group_location
  tags     = local.common_tags
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  vnet_cidr           = var.vnet_cidr
  subnet_cidrs        = var.subnet_cidrs
  tags                = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_id         = azurerm_resource_group.main.id
  resource_group_name       = azurerm_resource_group.main.name
  location                  = var.location
  name_prefix               = local.normalized_prefix
  suffix                    = local.suffix
  vm_subnet_id              = module.network.subnet_ids.vm
  vnet_id                   = module.network.vnet_id
  vm_size                   = var.vm_size
  admin_username            = var.vm_admin_username
  admin_ssh_public_key      = var.vm_admin_ssh_public_key
  deploy_developer_bastion  = true
  tags                      = local.common_tags
}

module "data" {
  source = "./modules/data"

  resource_group_id          = azurerm_resource_group.main.id
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  suffix                     = local.suffix
  storage_account_name       = local.storage_name
  postgresql_server_name     = local.postgresql_name
  postgresql_sku             = var.postgresql_sku
  postgresql_admin_username  = var.postgresql_admin_username
  postgresql_admin_password  = var.postgresql_admin_password
  entra_admin_object_id      = data.azurerm_client_config.current.object_id
  entra_admin_principal_name = var.entra_admin_principal_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  db_subnet_id               = module.network.subnet_ids.db
  endpoints_subnet_id        = module.network.subnet_ids.endpoints
  vnet_id                    = module.network.vnet_id
  tags                       = local.common_tags
}

module "app" {
  source = "./modules/app"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name_prefix         = local.normalized_prefix
  web_app_name        = local.web_app_name
  app_service_sku     = var.app_service_sku
  app_subnet_id       = module.network.subnet_ids.app
  postgresql_fqdn     = module.data.postgresql_fqdn
  storage_blob_url    = module.data.storage_blob_url
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "app_blob" {
  scope                = module.data.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.app.principal_id
}

resource "azurerm_role_assignment" "vm_blob" {
  scope                = module.data.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.compute.principal_id
}

