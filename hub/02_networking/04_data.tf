data "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-${var.project}-azsc1-law-${var.environment}-01"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_resource_group" "rg" {
  name = "${var.prefix}-${var.project}-azsc1-rg-${var.environment}-01"

}
