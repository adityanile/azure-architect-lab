<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.deploy_diag_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.cpu_metric_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.sql_dtu_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.storage_metric_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_subscription_policy_assignment.rg_deploy_diag_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_policy_set_definition.diag_alllogs_la](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_set_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_commitment_tier_gb_per_day"></a> [commitment\_tier\_gb\_per\_day](#input\_commitment\_tier\_gb\_per\_day) | Commitment Tier GB Per Day | `number` | `100` | no |
| <a name="input_email_receiver_address"></a> [email\_receiver\_address](#input\_email\_receiver\_address) | Email address for monitor action group notifications | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | This is the Environment For Deployment (Default: dev) | `string` | `"dev"` | no |
| <a name="input_name"></a> [name](#input\_name) | Give Your Workspace a Name | `string` | n/a | yes |
| <a name="input_retention_in_days_dev"></a> [retention\_in\_days\_dev](#input\_retention\_in\_days\_dev) | Days for Retention Dev | `number` | `30` | no |
| <a name="input_retention_in_days_prod"></a> [retention\_in\_days\_prod](#input\_retention\_in\_days\_prod) | Days for Retention Prod | `number` | `90` | no |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Location of the Resource Group | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the Resource Group | `string` | n/a | yes |
| <a name="input_sql_database_ids"></a> [sql\_database\_ids](#input\_sql\_database\_ids) | Pass the id's of SQL Server to monitor DTU Greater than 80% for 10 minutes | `list(string)` | n/a | yes |
| <a name="input_storage_account_ids"></a> [storage\_account\_ids](#input\_storage\_account\_ids) | Pass the id's of storage account to monitor for Storage above 80% Capacity | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to monitoring resources | `map(string)` | `{}` | no |
| <a name="input_vm_ids"></a> [vm\_ids](#input\_vm\_ids) | Pass the id's of the VM's for CPU usage about 85% for 5 Minutes | `list(string)` | n/a | yes |
| <a name="input_webhook_service_uri"></a> [webhook\_service\_uri](#input\_webhook\_service\_uri) | Webhook URL for monitor action group notifications | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_action_group_id"></a> [action\_group\_id](#output\_action\_group\_id) | Id to use for action group |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | This is the workspace id to use downstream |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | This is the workspace name to use downstream |
<!-- END_TF_DOCS -->