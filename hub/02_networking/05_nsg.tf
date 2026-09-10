module "hub_nsg" {
  source = "Azure/avm-res-network-networksecuritygroup/azurerm"

  name                = "${var.prefix}-${var.project}-azsc1-nsg-${var.environment}-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rules = {
    AllowVnetInbound = {
      name                       = "AllowVnetInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowVnetOutbound = {
      name                       = "AllowVnetOutbound"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowP2SPoolInbound = {
      name                       = "AllowP2SPoolInbound"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.16.0.0/24"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowP2SPoolOutbound = {
      name                       = "AllowP2SPoolOutbound"
      priority                   = 201
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "172.16.0.0/24"
    }

    AllowS2SInbound = {
      name                       = "AllowS2SInbound"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.240.0.0/24"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowS2SOutbound = {
      name                       = "AllowS2SOutbound"
      priority                   = 301
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "10.240.0.0/24"
    }

    DenyAllInbound = {
      name                       = "DenyAllInbound"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    DenyAllOutbound = {
      name                       = "DenyAllOutbound"
      priority                   = 4000
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

module "appgw_nsg" {
  source = "Azure/avm-res-network-networksecuritygroup/azurerm"

  name                = "${var.prefix}-${var.project}-azsc1-nsg-${var.environment}-02-appgw"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rules = {
    AllowHTTPInbound = {
      name                       = "AllowHTTPInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    AllowHTTPSInbound = {
      name                       = "AllowHTTPSInbound"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    AllowGatewayManagerHealthProbesInbound = {
      name                       = "AllowGatewayManagerHealthProbesInbound"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "65200-65545"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }

    AllowVnetInbound = {
      name                       = "AllowVnetInbound"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowAzureLoadBalancerHealthCheck80Inbound = {
      name                       = "AllowAzureLoadBalancerHealthCheck80Inbound"
      priority                   = 104
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }

    AllowAzureLoadBalancerHealthCheck443Inbound = {
      name                       = "AllowAzureLoadBalancerHealthCheck443Inbound"
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }

    # DenyAllInbound = {
    #   name                       = "DenyAllInbound"
    #   priority                   = 4000
    #   direction                  = "Inbound"
    #   access                     = "Deny"
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   destination_port_range     = "*"
    #   source_address_prefix      = "*"
    #   destination_address_prefix = "*"
    # }

    AllowVnetOutbound = {
      name                       = "AllowVnetOutbound"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    # DenyAllOutbound = {
    #   name                       = "DenyAllOutbound"
    #   priority                   = 4000
    #   direction                  = "Outbound"
    #   access                     = "Deny"
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   destination_port_range     = "*"
    #   source_address_prefix      = "*"
    #   destination_address_prefix = "*"
    # }
  }
}
