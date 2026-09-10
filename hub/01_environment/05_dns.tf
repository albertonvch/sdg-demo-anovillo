module "private_dns_zones" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  for_each            = var.private_dns_zones
  domain_name         = each.value
  resource_group_name = azurerm_resource_group.main.name

  virtual_network_links = {}

  tags             = var.tags
  enable_telemetry = false
}
