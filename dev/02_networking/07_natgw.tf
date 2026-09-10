resource "azurerm_public_ip" "pip_dev_natgw" {
  name                = "${var.prefix}-${var.project}-azsc1-pip-${var.environment}-nat-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "dev_natgw" {
  name                = "${var.prefix}-${var.project}-azsc1-nat-${var.environment}-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name

  sku_name = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "dev_natgw_pip_associations" {
  nat_gateway_id       = azurerm_nat_gateway.dev_natgw.id
  public_ip_address_id = azurerm_public_ip.pip_dev_natgw.id
}
