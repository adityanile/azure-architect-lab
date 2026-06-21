resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.rg_location

  sku                                = var.environment == "dev" ? "PerGB2018" : "CapacityReservation"
  reservation_capacity_in_gb_per_day = var.environment == "prod" ? var.commitment_tier_gb_per_day : null

  retention_in_days = var.environment == "dev" ? var.retention_in_days_dev : var.retention_in_days_prod
  tags              = var.tags
}

resource "azurerm_monitor_action_group" "this" {
  name                = "test-action-group-${var.environment}"
  resource_group_name = var.rg_name
  short_name          = "ag-${var.environment}"

  email_receiver {
    name          = "sendtoadmin"
    email_address = var.email_receiver_address
  }

  webhook_receiver {
    name        = "testapi"
    service_uri = var.webhook_service_uri
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "cpu_metric_alert" {
  name                = "cpu-metric-alert-${var.environment}"
  resource_group_name = var.rg_name
  count               = length(var.vm_ids) > 0 ? 1 : 0
  scopes              = tolist(var.vm_ids)
  description         = "Action will be triggered when CPU Utilisation is greater than 85%"
  window_size         = "PT5M"

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

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "storage_metric_alert" {
  name                = "storage-metric-alert-${var.environment}"
  resource_group_name = var.rg_name
  count               = length(var.storage_account_ids) > 0 ? 1 : 0
  scopes              = tolist(var.storage_account_ids)
  description         = "Action will be triggered when storage used capacity is greater than 500GB."
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 536870912000
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "sql_dtu_alert" {
  name                = "sql-dtu-alert-${var.environment}"
  resource_group_name = var.rg_name
  count               = length(var.sql_database_ids) > 0 ? 1 : 0
  scopes              = tolist(var.sql_database_ids)
  description         = "Action will be triggered when SQL DTU is greater than 80%"
  window_size         = "PT15M"

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

  tags = var.tags
}

data "azurerm_policy_set_definition" "diag_alllogs_la" {
  display_name = "Enable allLogs category group resource logging for supported resources to Log Analytics"
}

data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "rg_deploy_diag_policy" {
  name                 = "rg_deploy_diag_policy"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_set_definition.diag_alllogs_la.id
  location             = var.rg_location

  identity { type = "SystemAssigned" }

  parameters = jsonencode({
    logAnalytics = {
      value = "${azurerm_log_analytics_workspace.this.id}"
    }
    effect = {
      value = "DeployIfNotExists"
    }
  })
}

resource "azurerm_role_assignment" "diag_policy_monitoring_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_subscription_policy_assignment.rg_deploy_diag_policy.identity[0].principal_id
}

resource "azurerm_monitor_diagnostic_setting" "deploy_diag_setting" {
  for_each                   = toset(concat(var.vm_ids, var.sql_database_ids, var.storage_account_ids))
  name                       = "diag_${each.value}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm" {
  tier          = var.environment == "prod" ? "Standard" : "Free"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "sql" {
  tier          = var.environment == "prod" ? "Standard" : "Free"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "storage" {
  tier          = var.environment == "prod" ? "Standard" : "Free"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "container" {
  tier = var.environment == "prod" ? "Standard" : "Free"
  resource_type = "Containers"
}

resource "azurerm_application_insights_workbook" "test_workbook" {
  name                = var.workbook_id
  resource_group_name = var.rg_name
  location            = var.rg_location
  display_name        = "workbook-${var.environment}"
  data_json = jsonencode({
    "version" = "Notebook/1.0",
    "items" = [
      {
        "type" = 1,
        "content" = {
          "json" = "Test2026"
        },
        "name" = "text - 0"
      }
    ],
    "isLocked" = false,
    "fallbackResourceIds" = [
      "Azure Monitor"
    ]
  })

  tags = var.tags
}
