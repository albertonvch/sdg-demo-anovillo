module "log_analytics_workspace" {
  source = "Azure/avm-res-operationalinsights-workspace/azurerm"

  version             = "0.5.1"
  name                = "${var.prefix}-${var.project}-azsc1-law-${var.environment}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.id
  tags                = var.tags

  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }

  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_sku               = "PerGB2018"

  monitor_private_link_scope = {
    pe1 = {
      name        = "law_pl_scope"
      resource_id = azurerm_resource_group.main.id
    }
  }
  monitor_private_link_scoped_service_name = "law_pl_service"


}

module "storage_account" {
  source = "Azure/avm-res-storage-storageaccount/azurerm"

  name      = "${var.prefix}${var.project}azsc1sa${var.environment}01"
  location  = var.location
  parent_id = azurerm_resource_group.main.id
  tags      = var.tags

  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false

}

