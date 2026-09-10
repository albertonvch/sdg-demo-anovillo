module "vnet1" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"

  location      = var.location
  parent_id     = data.azurerm_resource_group.dev_rg.id
  address_space = var.address_space_vnet1

  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = "to-law"
      workspace_resource_id          = data.azurerm_log_analytics_workspace.hub_law.id
      log_analytics_destination_type = "Dedicated"
    }
  }


  encryption = {
    enabled     = true
    enforcement = "AllowUnencrypted"
  }

  flow_timeout_in_minutes = 30
  name                    = "${var.prefix}-${var.project}-azsc1-vnet-${var.environment}-01"

  peerings = {
    hub = {
      name                               = "${var.prefix}-${var.project}-azsc1-vnet-${var.environment}-01-to-${var.prefix}-${var.project}-azsc1-vnet-${var.hub_environment}-01"
      remote_virtual_network_resource_id = data.azurerm_virtual_network.hub.id
      allow_forwarded_traffic            = true
      allow_gateway_transit              = false
      allow_virtual_network_access       = true
      use_remote_gateways                = true
      create_reverse_peering             = true
      reverse_name                       = "${var.prefix}-${var.project}-azsc1-vnet-${var.hub_environment}-01-to-${var.prefix}-${var.project}-azsc1-vnet-${var.environment}-01"
      reverse_allow_forwarded_traffic    = true
      reverse_allow_gateway_transit      = false
      reverse_use_remote_gateways        = true
    }
  }

  subnets = local.subnets
}

data "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_zones

  name                  = "${each.key}-vnet-link-${var.environment}"
  resource_group_name   = data.azurerm_resource_group.hub_rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = module.vnet1.resource_id
  registration_enabled  = false
}

