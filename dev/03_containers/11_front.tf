module "frontend_storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.10.0"

  name      = "${var.prefix}${var.project}azsc1sa${var.environment}web01"
  location  = var.location
  parent_id = data.azurerm_resource_group.dev_rg.id
  tags      = var.tags

  account_kind                    = "StorageV2"
  account_sku_name                = "Standard_LRS"
  access_tier                     = "Hot"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  static_website = {
    default = {
      index_document     = "index.html"
      error_404_document = "404.html"
    }
  }

  private_endpoints = {
    blob = {
      name                          = "${var.prefix}${var.project}-azsc1-pe-blob-${var.environment}-01"
      subnet_resource_id            = data.azurerm_subnet.integration.id
      subresource_name              = "blob"
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.storage_blob.id]
    }
    web = {
      name                          = "${var.prefix}${var.project}-azsc1-pe-web-${var.environment}-01"
      subnet_resource_id            = data.azurerm_subnet.integration.id
      subresource_name              = "web"
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.storage_web.id]
    }
  }

  diagnostic_settings_blob = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.azurerm_log_analytics_workspace.hub_law.id
    }
  }
}
