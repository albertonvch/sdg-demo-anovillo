module "foundry" {
  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.11.1"

  kind      = "OpenAI"
  location  = var.location
  name      = "${var.prefix}-${var.project}-azsc1-aiservice-${var.environment}-01"
  parent_id = data.azurerm_resource_group.dev_rg.id

  local_auth_enabled = false


  sku_name = "S0"
  cognitive_deployments = {
    "gpt-4.1-mini" = {
      name = "gpt-4.1-mini"
      model = {
        format  = "OpenAI"
        name    = "gpt-4.1-mini"
        version = "2025-04-14"
      }
      scale = {
        type = "Standard"
      }
    }
  }
  enable_telemetry = false
  network_acls = {
    default_action = "Deny"
    virtual_network_rules = toset([{
      subnet_id = data.azurerm_subnet.integration.id
    }])
  }

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.ai_openai.id]
      subnet_resource_id            = data.azurerm_subnet.integration.id
    }
  }
}
