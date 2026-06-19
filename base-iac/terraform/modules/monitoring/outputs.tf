output "workspace_id" {
    description = "This is the workspace id to use downstream"
    value = azurerm_log_analytics_workspace.this.id
}

output "workspace_name" {
    description = "This is the workspace name to use downstream"
    value = azurerm_log_analytics_workspace.this.name
}

output "action_group_id" {
  description = "Id to use for action group"
  value = azurerm_monitor_action_group.this.id
}