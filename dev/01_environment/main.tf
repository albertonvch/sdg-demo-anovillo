resource "azurerm_resource_group" "main" {
  name     = "anovillo-${var.project}-azsc1-rg-${var.environment}-01"
  location = var.location

  tags = var.tags
}
