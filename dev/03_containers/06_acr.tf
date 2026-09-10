
resource "azurerm_user_assigned_identity" "umi_dev" {
  location            = var.location
  name                = "${var.prefix}${var.project}-azsc1-umi-${var.environment}"
  resource_group_name = data.azurerm_resource_group.dev_rg.name
}

resource "azurerm_role_assignment" "umi_dev_key_vault_crypto_user" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.umi_dev.principal_id
}


module "acr" {
  source = "Azure/avm-res-containerregistry-registry/azurerm"

  name                = "${var.prefix}${var.project}azsc1acr${var.environment}"
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

  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.azurerm_log_analytics_workspace.hub_law.id
    }
  }

  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = toset([azurerm_user_assigned_identity.umi_dev.id])
  }

  customer_managed_key = {
    key_vault_resource_id = module.key_vault.resource_id
    key_name              = local.cmk_dev_name
    user_assigned_identity = {
      resource_id = azurerm_user_assigned_identity.umi_dev.id
    }
  }
}

