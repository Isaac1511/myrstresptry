terraform {
  backend "azurerm" {
    resource_group_name  = "Multi_use_resource_group"
    storage_account_name = "storagedev010"                      
    container_name       = "stodev-tainer"                       
    key                  = "prod.terraform.tfstate"        
  }
}

# Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
# Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
# Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
# Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
