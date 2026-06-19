resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.rg_location

  sku                                = var.environment == "dev" ? "PerGB2018" : "CapacityReservation"
  reservation_capacity_in_gb_per_day = var.environment == "prd" ? var.commitment_tier_gb_per_day : null

  retention_in_days = var.environment == "dev" ? var.retention_in_days_dev : var.retention_in_days_prod
}

