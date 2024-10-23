# Define variables to be used with Terraform. 


# Define Sub-Id variable. 
variable "subscription_id" {
  type    = string
  default = "d40df8e9-d3c9-4a68-8333-af374546254c"
}

# Define Resource Group variable.
variable "resource_group_name" {
  type    = string
  default = "Multi_use_resource_group"
}

# Define Location variable.
variable "location" {
  type    = string
  default = "eastus"
}

# Define Virtual Network (vnet) variable.
variable "vnet_name" {
  type    = string
  default = "Multi_Use_VNet"
}

# Define Virtual Subnet (snet) variable.
variable "subnet_name" {
  type    = string
  default = "Multi_Use_SNet"
}

# Define Network Security Group (NSG) variable.
variable "nsg_name" {
  type    = string
  default = "Multi_Use_NSG"
}

# Define NIC variable
variable "NIC_name" {
  type    = string
  default = "Multi_Use_NC"
}

# Define Public IP
variable "Pup_name" {
  type    = string
  default = "Multi_Use_Pup_IP"
}

# Define Virtual Machine 1 variable.
variable "vm_name" {
  type    = string
  default = "TF-VM1"
}

# Define Virtual Machine 1 Credentials.
variable "vm_name_cre" {
  type    = string
  default = "adminqtecmai"
}
variable "vm_pass" {
  type    = string
  default = "P@ssword456rV$"
}