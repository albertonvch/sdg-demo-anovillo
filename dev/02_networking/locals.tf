locals {
  subnets = {
    integration = {
      name                            = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-integration-01"
      address_prefixes                = ["10.1.0.0/26"]
      default_outbound_access_enabled = false
      network_security_group = {
        id = module.dev_nsg.resource_id
      }
    }

    aca = {
      name                            = "${var.prefix}-${var.project}-az${var.region_code}-subnet-${var.environment}-aca-01"
      address_prefixes                = ["10.1.0.64/26"]
      default_outbound_access_enabled = false
      network_security_group = {
        id = module.dev_nsg.resource_id
      }
      nat_gateway = {
        id = azurerm_nat_gateway.dev_natgw.id
      }
      delegations = [{
        name = "aca_delegation"
        service_delegation = {
          name = "Microsoft.App/environments"
        }
      }]
    }
  }
}
