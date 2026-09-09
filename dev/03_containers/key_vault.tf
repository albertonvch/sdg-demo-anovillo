data "azurerm_client_config" "current" {}

module "key_vault" {
  source = "Azure/avm-res-keyvault-vault/azurerm"

  name                = "${var.prefix}${var.project}kv${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name

  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = false
  tags                          = var.tags

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.key_vault.id]
      subnet_resource_id            = data.azurerm_subnet.integration.id
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.azurerm_log_analytics_workspace.c.id
    }
  }
  keys = {
    BYOK_CMK_DEV = {
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      key_type = "RSA"
      name     = "cmk-for-dev"
      key_size = 2048
  } }
}

