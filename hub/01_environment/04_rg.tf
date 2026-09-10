#Already created resource group, import it to the state file using the following command


import {
  to = azurerm_resource_group.main
  id = "/subscriptions/f869a214-6f5d-4c4f-a077-f197558e06d1/resourceGroups/anovillo-sdg-azsc1-rg-hub-01"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.project}-azsc1-rg-${var.environment}-01"
  location = var.location

  tags = var.tags
}

