
locals {
  cmk_key_uri  = azapi_resource.cmk_dev.output.properties.keyUriWithVersion
  cmk_key_id   = azapi_resource.cmk_dev.output.properties.keyUri
  cmk_dev_name = "cmk-for-dev"
}
