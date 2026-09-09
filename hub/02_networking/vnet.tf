module "vnet1" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"

  location      = var.location
  parent_id     = data.azurerm_resource_group.this.id
  address_space = var.address_space_vnet1

  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = "to-law"
      workspace_resource_id          = data.azurerm_log_analytics_workspace.law.id
      log_analytics_destination_type = "Dedicated"
    }
  }


  encryption = {
    enabled     = true
    enforcement = "AllowUnencrypted"
  }

  flow_timeout_in_minutes = 30
  name                    = "${var.prefix}-${var.project}-azsc1-vnet-${var.environment}-01"


  subnets = local.subnets
}

data "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_zones

  name                  = "${each.key}-vnet-link"
  resource_group_name   = data.azurerm_resource_group.this.name
  private_dns_zone_name = each.value
  virtual_network_id    = module.vnet1.resource_id
  registration_enabled  = false
}

