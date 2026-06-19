output "workspace_id" {
    description = "This is the workspace id to use downstream"
    value = azurerm_log_analytics_workspace.this.id
}

output "workspace_name" {
    description = "This is the workspace name to use downstream"
    value = azurerm_log_analytics_workspace.this.name
}