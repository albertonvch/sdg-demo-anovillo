locals {
  subnets = {
    integration = {
      name                            = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-integration-01"
      address_prefixes                = ["10.0.0.0/26"]
      default_outbound_access_enabled = false
      network_security_group = {
        id = module.hub_nsg.resource_id
      }
    }

    application_gateway = {
      name                            = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-appgw-01"
      address_prefixes                = ["10.0.0.64/26"]
      default_outbound_access_enabled = false
      network_security_group = {
        id = module.appgw_nsg.resource_id
      }
    }

    gateway = {
      name                            = "GatewaySubnet"
      address_prefixes                = ["10.0.0.128/26"]
      default_outbound_access_enabled = false
      network_security_group = {
        id = module.hub_nsg.resource_id
      }
    }
  }
}
