resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.rg_location

  sku                                = var.environment == "dev" ? "PerGB2018" : "CapacityReservation"
  reservation_capacity_in_gb_per_day = var.environment == "prod" ? var.commitment_tier_gb_per_day : null

  retention_in_days = var.environment == "dev" ? var.retention_in_days_dev : var.retention_in_days_prod
}

resource "azurerm_monitor_action_group" "this" {
  name = "test-action-group-${var.environment}"
  resource_group_name = var.rg_name
  short_name = "ag-${var.environment}"

  email_receiver {
    name          = "sendtoadmin"
    email_address = "adityanile@gmail.com"
  }

  webhook_receiver {
    name        = "testapi"
    service_uri = "https://adityanile.me/"
  }
}

resource "azurerm_monitor_metric_alert" "cpu_metric_alert" {
  name                = "cpu-metric-alert-${var.environment}"
  resource_group_name = var.rg_name
  scopes              = tolist(var.vm_ids)
  description         = "Action will be triggered when CPU Utilisation is greater than 85%"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

resource "azurerm_monitor_metric_alert" "storage_metric_alert" {
  name                = "storage-metric-alert-${var.environment}"
  resource_group_name = var.rg_name
  scopes              = tolist(var.storage_account_ids)
  description         = "Action will be triggered when storage used capacity is greater than 80."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

resource "azurerm_monitor_metric_alert" "sql_dtu_alert" {
  name                = "sql-dtu-alert-${var.environment}"
  resource_group_name = var.rg_name
  scopes              = tolist(var.sql_database_ids)
  description         = "Action will be triggered when SQL DTU is greater than 80%"
  window_size = "PT15M"

  criteria {
      metric_namespace = "Microsoft.Sql/servers/databases"
      metric_name      = "dtu_consumption_percent"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 80
    }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

data "azurerm_policy_set_definition" "diag_alllogs_la" {
    display_name = "Enable allLogs category group resource logging for supported resources to Log Analytics"
}

resource "azurerm_resource_group_policy_assignment" "rg_deploy_diag_policy" {
  name                 = "rg_deploy_diag_policy"
  resource_group_id    = var.rg_id
  policy_definition_id = data.azurerm_policy_set_definition.diag_alllogs_la.id
  location = var.rg_location

  identity {type = "SystemAssigned"}

  parameters = jsonencode({
      logAnalytics = {
        value = "${azurerm_log_analytics_workspace.this.id}"
      }
      effect = {
        value = "DeployIfNotExists"
      }
    })
}