locals {
  agw_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationGateways/${var.prefix}${var.project}-azsc1-agw-${var.environment}-01"
}


resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "${var.prefix}${var.project}-azsc1-waf-${var.environment}-01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location




  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "too-tasty"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920300"
          enabled = true
          action  = "Log"
        }

        rule {
          id      = "920440"
          enabled = true
          action  = "Block"
        }
      }
    }
  }
}
resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.prefix}${var.project}-azsc1-pip-${var.environment}-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "application_gateway" {
  source  = "Azure/avm-res-network-applicationgateway/azurerm"
  version = "0.5.3"

  location = var.location
  # provide Application gateway name
  name      = "${var.prefix}${var.project}-azsc1-agw-${var.environment}-01"
  parent_id = data.azurerm_resource_group.rg.id
  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 2
  }

  # Backend address pool configuration for the application gateway
  # Mandatory Input
  backend_address_pools = [
    {
      name = "appGatewayBackendPool"
      properties = {
        backend_addresses = [
          { fqdn = "anovillo-sdg-azsc1-aca-dev-back.blackground-d35e4e46.swedencentral.azurecontainerapps.io" }
        ]
      }
    }
  ]
  # Backend http settings configuration for the application gateway
  # Mandatory Input
  backend_http_settings_collection = [
    {
      name = "appGatewayBackendHttpSettings"
      properties = {
        port            = 8000
        protocol        = "Http"
        path            = "/"
        request_timeout = 30
        probe = {
          id = "${local.agw_id}/probes/Probe1"
        }
      }
    }
  ]


  probes = [
    {
      name = "Probe1"
      properties = {
        interval                                  = 30
        timeout                                   = 10
        unhealthy_threshold                       = 3
        protocol                                  = "Http"
        port                                      = 8000
        path                                      = "/health"
        host                                      = "127.0.0.1"
        pick_host_name_from_backend_http_settings = false
        # Note on host : The Hostname used for this Probe. If the Application Gateway is configured for a single site,
        # by default the Host name should be specified as 127.0.0.1,
        # unless otherwise configured in custom probe.
        # Cannot be set if pick_host_name_from_backend_http_settings is set to true.
        # You must provide host value if pick_host_name_from_backend_http_settings is set to false.
        match = {
          body         = null
          status_codes = ["200-399"]
        }
      }
    }
  ]

  # WAF : Monitor and Log the configurations and traffic
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
    }
  }

  # WAF : Use Application Gateway with Web Application Firewall (WAF) in an application virtual network to safeguard inbound HTTP/S internet traffic. WAF offers centralized defense against potential exploits through OWASP core rule sets-based rules.
  # Ensure that you have a WAF policy created before enabling WAF on the Application Gateway
  # The use of an external WAF policy is recommended rather than using the classic WAF via the waf_configuration block.
  firewall_policy = {
    id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/${azurerm_web_application_firewall_policy.waf.name}"
  }
  frontend_ip_configurations = [
    {
      name = "appGatewayFrontendPublicIP"
      properties = {
        public_ip_address = {
          id = azurerm_public_ip.appgw_pip.id
        }
      }
    }
  ]
  # frontend port configuration block for the application gateway
  # WAF : This example NO HTTPS, We recommend to  Secure all incoming connections using HTTPS for production services with end-to-end SSL/TLS or SSL/TLS termination at the Application Gateway to protect against attacks and ensure data remains private and encrypted between the web server and browsers.
  # WAF : Please refer kv_selfssl_waf_https_app_gateway example for HTTPS configuration
  frontend_ports = [
    {
      name = "frontend-port-80"
      properties = {
        port = 80
      }
    }
  ]
  gateway_ip_configurations = [
    {
      name = "appGatewayIpConfig"
      properties = {
        subnet = {
          id = module.vnet1.subnets["application_gateway"].resource_id
        }
      }
    }
  ]
  # Http Listerners configuration for the application gateway
  # Mandatory Input
  http_listeners = [
    {
      name = "appGatewayHttpListener"
      properties = {
        frontend_ip_configuration = {
          id = "${local.agw_id}/frontendIPConfigurations/appGatewayFrontendPublicIP"
        }
        frontend_port = {
          id = "${local.agw_id}/frontendPorts/frontend-port-80"
        }
        protocol = "Http"
      }
    }
  ]
  # Routing rules configuration for the backend pool
  # Mandatory Input
  request_routing_rules = [
    {
      name = "rule-1"
      properties = {
        rule_type = "Basic"
        http_listener = {
          id = "${local.agw_id}/httpListeners/appGatewayHttpListener"
        }
        backend_address_pool = {
          id = "${local.agw_id}/backendAddressPools/appGatewayBackendPool"
        }
        backend_http_settings = {
          id = "${local.agw_id}/backendHttpSettingsCollection/appGatewayBackendHttpSettings"
        }
        priority = 100
      }
    }
  ]
  # WAF : Azure Application Gateways v2 are always deployed in a highly available fashion with multiple instances by default. Enabling autoscale ensures the service is not reliant on manual intervention for scaling.
  sku = {
    # Accpected value for names Standard_v2 and WAF_v2
    name = "WAF_v2"
    # Accpected value for tier Standard_v2 and WAF_v2
    tier = "WAF_v2"
  }
  tags = var.tags
  # Optional Input
  # Zone redundancy for the application gateway ["1", "2", "3"]
  zones = ["1", "2", "3"]
}
