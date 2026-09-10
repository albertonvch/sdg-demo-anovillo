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
  public_network_access_enabled = true
  #   network_acls = {
  #     bypass         = "AzureServices"
  #     default_action = "Allow"
  #   }
  network_acls = null #temporal while deplying infraestructure
  tags         = var.tags

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.key_vault.id]
      subnet_resource_id            = data.azurerm_subnet.integration.id
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.azurerm_log_analytics_workspace.hub_law.id
    }
  }
}


resource "azapi_resource" "cmk_dev" {
  type      = "Microsoft.KeyVault/vaults/keys@2023-07-01"
  name      = "cmk-for-dev"
  parent_id = module.key_vault.resource_id

  body = {
    properties = {
      kty     = "RSA"
      keySize = 2048
      keyOps  = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
      attributes = {
        enabled = true
      }
    }
  }

  response_export_values = ["properties.keyUri", "properties.keyUriWithVersion"]
}
