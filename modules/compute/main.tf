resource "azurerm_network_interface" "worker" {
  name                = "nic-vm-${var.name_prefix}-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "worker" {
  name                            = "vm-${var.name_prefix}-${var.suffix}"
  computer_name                   = "vm-worker"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.worker.id]
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    name                 = "osdisk-vm-${var.name_prefix}-${var.suffix}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
  }
}

# AzureRM does not yet model the free Developer SKU. AzAPI uses the same ARM
# control plane and avoids the paid dedicated host and public IP.
resource "azapi_resource" "bastion_developer" {
  count = var.deploy_developer_bastion ? 1 : 0

  type      = "Microsoft.Network/bastionHosts@2024-10-01"
  name      = "bas-${var.name_prefix}-${var.suffix}"
  parent_id = var.resource_group_id
  location  = var.location
  tags      = var.tags

  body = {
    sku = {
      name = "Developer"
    }
    properties = {
      virtualNetwork = {
        id = var.vnet_id
      }
    }
  }
}

