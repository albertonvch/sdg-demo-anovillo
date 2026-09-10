

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

data "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-${var.project}-azsc1-vnet-${var.hub_environment}-01"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}
