locals {
  sanitized_suffix = replace(var.suffix, "-", "")
  storage_name     = substr("${var.project_name}${local.sanitized_suffix}", 0, 24)
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project_name}-${var.suffix}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = merge(var.tags, {
    Name = local.storage_name
  })
}

resource "azurerm_storage_account_static_website" "this" {
  storage_account_id = azurerm_storage_account.this.id
  index_document     = "index.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = var.index_html
  content_type           = "text/html"
}
