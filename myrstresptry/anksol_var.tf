# Define variables to be used with Terraform. 

# Define Sub-Id variable. 
variable "subscription_id" {
  type    = string
  default = "d40df8e9-d3c9-4a68-8333-af374546254c"
}

# Define Resource Group variable.
variable "resource_group_name" {
  type    = string
  default = "anksolrgvk"
}

# Define Location variable.
variable "location" {
  type    = string
  default = "eastus"
}

# Define Virtual Network (vnet) variable.
variable "vnet_name" {
  type    = string
  default = "myVnet00121"
}

# Define Virtual Subnet (snet) variable.
variable "subnet_name" {
  type    = string
  default = "mySnet12100"
}

# Define Network Security Group (NSG) variable.
variable "nsg_name" {
  type    = string
  default = "myNSG001"
}

# Added Custom IP Inbound & Outbound rule
variable "my_ip_address" {
  description = "IP address to allow outbound traffic"
  type        = string
  default     = "10.0.0.47" # Replace this with your actual IP address or remove the default to pass it at runtime
}


# Define Public IP variable
variable "NIC1pubipname" {
  type    = string
  default = "cont-vm-puip01"
}

# Define Public IP variable
variable "NIC2pubipname" {
  type    = string
  default = "host-vm-puip02"
}

# Define Virtual Machine 1 variable.
variable "control_vm" {
  type    = string
  default = "anksol-controller01"
}

# Define Virtual Machine 2 variable.
variable "host_vm" {
  type    = string
  default = "anksol-host02"
}

# Define Virtual Machine 1 Network Interface Card (NIC) variable.
variable "control_nic" {
  type    = string
  default = "control-nic01"
}

# Define Virtual Machine 2 Network Interface Card (NIC) variable.
variable "host_nic" {
  type    = string
  default = "host-nic02"
}

# Define Virtual Machine 1 Credentials.
variable "controllervm_name" {
  type    = string
  default = "adminqtecmai"
}
variable "controllervm_password" {
  type    = string
  default = "P@ssword456rV$"
}

# Define Virtual Machine 2 Credentials.
variable "hostvm_name" {
  type    = string
  default = "usersqtech"
}
variable "hostvm_password" {
  type    = string
  default = "Ynae25iasdfas"
}