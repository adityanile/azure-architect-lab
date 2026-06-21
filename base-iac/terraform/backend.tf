terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.74.0"
    }
  }
  # Backend values are supplied via -backend-config=backend.<env>.hcl at init time.
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

module "azure_monitoring_module" {

  source = "./modules/monitoring"

  name                = var.log_analytics_workspace_name
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  vm_ids              = []
  sql_database_ids    = []
  storage_account_ids = []

  webhook_service_uri    = var.webhook_service_uri
  email_receiver_address = var.email_receiver_address

  tags = var.tags
  workbook_id = "85b3e8bb-fc93-40be-83f2-98f6bec18ba0"

}
