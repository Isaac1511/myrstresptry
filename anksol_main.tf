# Project Brick by Brick: Build out and test creation of vnet, snet, 2 VMs, etc: 

# Define Providers and features
terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=1.6.4"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}

  subscription_id = var.subscription_id
}

#Creating resource group 
resource "azurerm_resource_group" "AnkSolRGtf" {
  name     = var.resource_group_name
  location = var.location
}

#Creating local state files 4/7/24@1047
terraform {}


# Create virtual network
resource "azurerm_virtual_network" "tfvnetname" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_resource_group.AnkSolRGtf] # This ensures that the virtual network waits for the resource group to be created

  tags = {
    environment = "Terraform Networking"
  }
}

# Create subnet - Both VMs will be on the same subnet.
resource "azurerm_subnet" "tfsubnet1name" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.tfvnetname.name
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [azurerm_virtual_network.tfvnetname] # This ensures that the Subnet waits for the virtual network to be created

}

# Create NSG
resource "azurerm_network_security_group" "tfnsgname" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_subnet.tfsubnet1name] # This ensures that the Subnet waits for the virtual network to be created

  tags = {
    environment = "Terraform Networking"
  }
}


# Add Custom IP Inbound rules
resource "azurerm_network_security_rule" "tfallowcustin" {
  name                        = "AllowCustomIPInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" # updated source port range from 2 to any
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = var.my_ip_address
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_rule.tfallowcustout]
}

resource "azurerm_network_security_rule" "tfallowsshin" {
  name                        = "AllowSSHIn"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" # updated source port range from 2 to any
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_rule.tfallowcustin] # This ensures that the Subnet waits for the virtual network to be created
}

resource "azurerm_network_security_rule" "tfallowwebin" {
  name                        = "AllowwebIn"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" # updated the dest port range from 8080 to any.
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_rule.tfallowsshin] # This ensures that the Subnet waits for the virtual network to be created
}

# Create custum outbound NSG rules
resource "azurerm_network_security_rule" "tfallowcustout" {
  name                        = "AllowCustomIPOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" # updated source port range from 2 to any
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = var.my_ip_address
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_group.tfnsgname]
}

resource "azurerm_network_security_rule" "tfallowsshout" {
  name                        = "SSH"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*" # updated source port range from 2 to any
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_rule.tfallowwebin] # This ensures that the Subnet waits for the virtual network to be created
}


resource "azurerm_network_security_rule" "tfdenyoutwebout" {
  name                        = "DenyOutWebOut"
  priority                    = 104
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.tfnsgname.name

  depends_on = [azurerm_network_security_rule.tfallowsshout] # This ensures that the Subnet waits for the virtual network to be created
}


# Create public IP address for control_nic
resource "azurerm_public_ip" "tfnic1_public_ip" {
  name                = var.NIC1pubipname
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  depends_on = [azurerm_network_security_rule.tfdenyoutwebout] # This ensures that the Subnet waits for the virtual network to be created
}

#Create private address for control_nic
resource "azurerm_network_interface" "tfmynic1" {
  name                = var.control_nic
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.tfsubnet1name.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfnic1_public_ip.id
  }

  depends_on = [azurerm_public_ip.tfnic1_public_ip] # This ensures that Subnet waits for virtual network to be created
}

# Associate NSG with control_nic
resource "azurerm_network_interface_security_group_association" "tf_nic1_nsg_association" {
  network_interface_id      = azurerm_network_interface.tfmynic1.id
  network_security_group_id = azurerm_network_security_group.tfnsgname.id

  depends_on = [azurerm_network_interface.tfmynic1] # Ensure NIC1 is created before associating
}

# Create public IP address for host_nic
resource "azurerm_public_ip" "tfnic2_public_ip" {
  name                = var.NIC2pubipname
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  depends_on = [azurerm_network_interface.tfmynic1] # This ensures that PUB NIC2 waits for to be created
}

#Create private address for host_nic
resource "azurerm_network_interface" "tfmynic2" {
  name                = var.host_nic
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.tfsubnet1name.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfnic2_public_ip.id
  }

  depends_on = [azurerm_public_ip.tfnic2_public_ip] # This ensures that NIC2 waits for Pub NIC2 to be created
}

# Associate NSG with host_nic
resource "azurerm_network_interface_security_group_association" "tf_nic2_nsg_association" {
  network_interface_id      = azurerm_network_interface.tfmynic2.id
  network_security_group_id = azurerm_network_security_group.tfnsgname.id
}

# Create Controller virtual machine 
resource "azurerm_linux_virtual_machine" "tfmyfstlinvm001" {
  name                = var.control_vm
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"

  admin_username                  = var.controllervm_name
  admin_password                  = var.controllervm_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.tfmynic1.id]

  depends_on = [azurerm_network_interface.tfmynic2] # This ensures that VM1 waits for NIC2 to be created
}


# Create Host virtual machine
resource "azurerm_linux_virtual_machine" "tfmyfstlinvm002" {
  name                = var.host_vm
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"

  admin_username                  = var.hostvm_name
  admin_password                  = var.hostvm_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.tfmynic2.id]

  depends_on = [azurerm_linux_virtual_machine.tfmyfstlinvm001] # This ensures that VM2 waits for VM1 to be created
}


#Creating local state files 
terraform {}