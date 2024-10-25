terraform {
  backend "azurerm" {
    resource_group_name  = "Multi_use_resource_group"
    storage_account_name = "storagedev010"                      
    container_name       = "stodev-tainer"                       
    key                  = "prod.terraform.tfstate"        
  }
}

