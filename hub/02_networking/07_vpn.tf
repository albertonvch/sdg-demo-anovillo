
resource "azurerm_public_ip" "vpn_pip" {
  name                = "${var.prefix}-${var.project}-azsc1-vpn-pip-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                = "${var.prefix}-${var.project}-azsc1-vpn-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  bgp_enabled   = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet1.subnets["gateway"].resource_id
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]
  }
}
