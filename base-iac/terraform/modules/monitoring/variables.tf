variable "environment" {
  default     = "dev"
  type        = string
  description = "This is the Environment For Deployment (Default: dev)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev or prod."
  }
}

variable "name" {
  type        = string
  description = "Give Your Workspace a Name"
}

variable "rg_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "rg_location" {
  type        = string
  description = "Location of the Resource Group"
}

variable "retention_in_days_dev" {
  type = number
  description = "Days for Retention Dev"
  default = 30
}

variable "retention_in_days_prod" {
  type = number
  description = "Days for Retention Prod"
  default = 90
}

variable "commitment_tier_gb_per_day" {
  type = number
  description = "Commitment Tier GB Per Day"
  default = 100
}

variable "vm_ids" {
  type = list(string)
  description = "Pass the id's of the VM's for CPU usage about 85% for 5 Minutes"
}

variable "storage_account_ids" {
  type = list(string)
  description = "Pass the id's of storage account to monitor for Storage above 80% Capacity"
}

variable "sql_database_ids" {
  type = list(string)
  description = "Pass the id's of SQL Server to monitor DTU Greater than 80% for 10 minutes"
}

variable "rg_id" {
  type = string
  description = "Provide the resource group Id for the Policy Assignment"
}
