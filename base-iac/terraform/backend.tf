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


