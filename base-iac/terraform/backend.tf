terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.74.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dev-anile"
    storage_account_name = "niletest"
    container_name       = "terraform"
    key                  = "test-terraform.state"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-nile"
  location = "centralindia"
}

module "azure_monitoring_module" {

  source = "./modules/monitoring"

  name                = "test-workspace"
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  rg_id               = azurerm_resource_group.rg.id
  vm_ids              = []
  sql_database_ids    = []
  storage_account_ids = []
}
