output "resource_group_name" {
  description = "Azure resource group name."
  value       = azurerm_resource_group.this.name
}

output "storage_account_name" {
  description = "Azure storage account name."
  value       = azurerm_storage_account.this.name
}

output "website_url" {
  description = "Azure static website endpoint URL."
  value       = azurerm_storage_account.this.primary_web_endpoint
}
