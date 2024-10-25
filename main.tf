# Define Providers and features
terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.5.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}



# Data block to reference an existing resource group.
data "azurerm_resource_group" "DevLabTF-RG" {
  name = var.resource_group_name
}

# Data block to reference the existing virtual network.
data "azurerm_virtual_network" "DevLabTF-Vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.DevLabTF-RG.name
}

# Data block to reference the existing subnet within the virtual network.
data "azurerm_subnet" "DevLabTF-Snet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.DevLabTF-RG.name
  virtual_network_name = data.azurerm_virtual_network.DevLabTF-Vnet.name
}

# Data block to reference the existing NIC within the subnet.
data "azurerm_network_interface" "DevLabTF-NIC" {
  name                = var.NIC_name
  resource_group_name = data.azurerm_resource_group.DevLabTF-RG.name
}

# Resource block to reference the newly created VM.
resource "azurerm_linux_virtual_machine" "DevLabTF-vm001" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"

  admin_username                  = var.vm_name_cre
  admin_password                  = var.vm_pass
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface_ids = [data.azurerm_network_interface.DevLabTF-NIC.id]
}