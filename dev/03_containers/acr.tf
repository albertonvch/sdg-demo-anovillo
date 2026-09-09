module "acr" {
  source = "Azure/avm-res-containerregistry-registry/azurerm"

  name                = "${var.prefix}${var.project}acr${var.environment}"
  resource_group_name = data.azurerm_resource_group.dev_rg.name
  location            = var.location

  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
  zone_redundancy_enabled       = false
  tags                          = var.tags

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [
        data.azurerm_private_dns_zone.acr.id
      ]
      subnet_resource_id = data.azurerm_subnet.integration.id
    }
  }
}

