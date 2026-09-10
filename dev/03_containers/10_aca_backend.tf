


resource "azurerm_container_app" "container_backend" {
  name                         = "${var.prefix}-${var.project}-azsc1-aca-${var.environment}-backend"
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = data.azurerm_resource_group.dev_rg.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "SystemAssigned"
  }
  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }



  tags = var.tags

  lifecycle {
    ignore_changes = [
      template, ingress, revision_mode, secret, registry
    ]
  }
}




resource "azurerm_role_assignment" "container_backend_kv_access" {
  scope              = module.key_vault.resource_id
  role_definition_id = data.azurerm_role_definition.key_vault_secrets_user.id
  principal_id       = azurerm_container_app.container_backend.identity[0].principal_id

  lifecycle {
    ignore_changes = [role_definition_id]
  }
}


resource "azurerm_role_assignment" "container_backend_acr_pull" {
  scope              = module.acr.resource_id
  role_definition_id = data.azurerm_role_definition.acr_pull.id
  principal_id       = azurerm_container_app.container_backend.identity[0].principal_id

  lifecycle {
    ignore_changes = [role_definition_id]
  }
}



