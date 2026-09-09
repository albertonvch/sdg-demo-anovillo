
locals {
  cmk_key_uri = azapi_resource.cmk_dev.output.properties.keyUriWithVersion
}
