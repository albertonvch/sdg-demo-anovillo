# module "cosmosdb" {
#   source = "Azure/avm-res-documentdb-databaseaccount/azurerm"

#   location            = var.location
#   name                = "${var.prefix}-${var.project}-azsc1-cosmosdb-${var.environment}-01"
#   resource_group_name = data.azurerm_resource_group.dev_rg.name
#   ip_range_filter = [
#     "13.91.105.215", "4.210.172.107", "13.88.56.148", "40.91.218.243"
#   ]
#   network_acl_bypass_for_azure_services = true
#   public_network_access_enabled         = true
#   virtual_network_rules = [
#     {
#       subnet_id = data.azurerm_subnet.integration.id
#     },
#     {
#       subnet_id = data.azurerm_subnet.aca.id
#     }
#   ]
# }
