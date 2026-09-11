module "cosmosdb" {
  source  = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version = "0.10.0"

  name                = "${var.prefix}-${var.project}-azsc1-cosmosdb-${var.environment}-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name

  capabilities = [
    {
      name = "EnableServerless"
    }
  ]

  consistency_policy = {
    consistency_level = "Session"
  }

  geo_locations = [
    {
      location          = var.location
      failover_priority = 0
      zone_redundant    = false
    }
  ]

  ip_range_filter = [
    "13.91.105.215",
    "4.210.172.107",
    "13.88.56.148",
    "40.91.218.243"
  ]

  network_acl_bypass_for_azure_services = true
  public_network_access_enabled         = false

  private_endpoints = {
    sql = {
      name                          = "${var.prefix}${var.project}-azsc1-pe-cosmos-sql-${var.environment}-01"
      subnet_resource_id            = data.azurerm_subnet.integration.id
      subresource_name              = "SQL"
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.cosmos_sql.id]
    }
  }
}

