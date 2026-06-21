variable "rg_name" {
  type        = string
  description = "Resource group name for base deployment"
}

variable "rg_location" {
  type        = string
  description = "Azure region for base deployment"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics workspace name used by the monitoring module"
}

variable "email_receiver_address" {
  type        = string
  description = "Email address used by action group notifications"
}

variable "webhook_service_uri" {
  type        = string
  description = "Webhook URL used by action group notifications"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to base resources"
  default     = {}
}
