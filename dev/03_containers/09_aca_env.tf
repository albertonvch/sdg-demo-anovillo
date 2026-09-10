

resource "azurerm_container_app_environment" "aca_environment" {
  location            = var.location
  name                = "${var.prefix}-${var.project}-azsc1-aca-${var.environment}-01"
  resource_group_name = data.azurerm_resource_group.dev_rg.name

  infrastructure_resource_group_name = "MC_ACA${var.prefix}-${var.project}-azsc1-rg-${var.environment}"
  infrastructure_subnet_id           = data.azurerm_subnet.aca.id

  internal_load_balancer_enabled = true
  workload_profile {
    maximum_count         = 0
    minimum_count         = 0
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}



