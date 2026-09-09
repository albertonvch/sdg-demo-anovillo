project     = "sdg"
environment = "hub"
prefix      = "anovillo"

tags = {
  "environment" = "hub"
  "terraform"   = "true"
  "region"      = "Sweden Central"
  "responsable" = "anovillo"

}


private_dns_zones = {
  storage_blob = "privatelink.blob.core.windows.net"
  storage_web  = "privatelink.web.core.windows.net"

  key_vault = "privatelink.vaultcore.azure.net"

  container_apps = "privatelink.swedencentral.azurecontainerapps.io"

  cosmos_sql = "privatelink.documents.azure.com"

  data_factory        = "privatelink.datafactory.azure.net"
  data_factory_portal = "privatelink.adf.azure.com"

  container_registry = "privatelink.azurecr.io"

  monitor          = "privatelink.monitor.azure.com"
  monitor_oms      = "privatelink.oms.opinsights.azure.com"
  monitor_ods      = "privatelink.ods.opinsights.azure.com"
  monitor_agentsvc = "privatelink.agentsvc.azure-automation.net"

  ai_cognitive_services = "privatelink.cognitiveservices.azure.com"
  ai_openai             = "privatelink.openai.azure.com"
  ai_services           = "privatelink.services.ai.azure.com"
}
