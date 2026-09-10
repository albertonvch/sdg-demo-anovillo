

data "azurerm_resource_group" "dev_rg" {
  name = "${var.prefix}-${var.project}-azsc1-rg-${var.environment}-01"

}

data "azurerm_resource_group" "hub_rg" {
  name = "${var.prefix}-${var.project}-azsc1-rg-${var.hub_environment}-01"

}

data "azurerm_log_analytics_workspace" "hub_law" {
  name                = "${var.prefix}-${var.project}-azsc1-law-${var.hub_environment}-01"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.project}-azsc1-vnet-${var.environment}-01"
  resource_group_name = data.azurerm_resource_group.dev_rg.name
}

data "azurerm_subnet" "integration" {
  name                 = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-integration-01"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.dev_rg.name
}


data "azurerm_subnet" "aca" {
  name                 = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-aca-01"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.dev_rg.name
}

data "azurerm_private_dns_zone" "storage_blob" {
  name                = var.private_dns_zones["storage_blob"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_private_dns_zone" "storage_web" {
  name                = var.private_dns_zones["storage_web"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_private_dns_zone" "acr" {
  name                = var.private_dns_zones["container_registry"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_private_dns_zone" "key_vault" {
  name                = var.private_dns_zones["key_vault"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_private_dns_zone" "ai_openai" {
  name                = var.private_dns_zones["ai_openai"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_private_dns_zone" "cosmos_sql" {
  name                = var.private_dns_zones["cosmos_sql"]
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}



data "azurerm_role_definition" "key_vault_secrets_user" {
  name = "Key Vault Secrets User"
}


data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}
