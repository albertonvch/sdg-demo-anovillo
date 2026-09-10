module "dev_nsg" {
  source = "Azure/avm-res-network-networksecuritygroup/azurerm"

  name                = "${var.prefix}-${var.project}-azsc1-nsg-${var.environment}-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name

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


    AllowAcaToAcrOutbound = {
      name                       = "AllowAcaToAcrOutbound"
      access                     = "Allow"
      destination_address_prefix = "MicrosoftContainerRegistry"
      destination_port_range     = "443"
      direction                  = "Outbound"
      priority                   = 302
      protocol                   = "Tcp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowAcaToFrontDoorOutbound = {
      name                       = "AllowAcaToFrontDoorOutbound"
      access                     = "Allow"
      destination_address_prefix = "AzureFrontDoor.FirstParty"
      destination_port_range     = "443"
      direction                  = "Outbound"
      priority                   = 303
      protocol                   = "Tcp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowAcaToAcaOutbound = {
      name                         = "AllowAcaToAcaOutbound"
      access                       = "Allow"
      destination_address_prefixes = local.subnets["aca"].address_prefixes
      destination_port_range       = "*"
      direction                    = "Outbound"
      priority                     = 304
      protocol                     = "Tcp"
      source_address_prefixes      = local.subnets["aca"].address_prefixes
      source_port_range            = "*"
    }
    AllowAcaToAadOutbound = {
      name                       = "AllowAcaToAadOutbound"
      access                     = "Allow"
      destination_address_prefix = "AzureActiveDirectory"
      destination_port_range     = "443"
      direction                  = "Outbound"
      priority                   = 305
      protocol                   = "Tcp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowAcaToAzureDnsUdpOutbound = {
      name                       = "AllowAcaToAzureDnsUdpOutbound"
      access                     = "Allow"
      destination_address_prefix = "AzureActiveDirectory"
      destination_port_range     = "53"
      direction                  = "Outbound"
      priority                   = 306
      protocol                   = "Udp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowAcaToAzureDnsTcpOutbound = {
      name                       = "AllowAcaToAzureDnsTcpOutbound"
      access                     = "Allow"
      destination_address_prefix = "AzureActiveDirectory"
      destination_port_range     = "53"
      direction                  = "Outbound"
      priority                   = 307
      protocol                   = "Tcp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowAcaToStorageOutbound = {
      name                       = "AllowAcaToStorageOutbound"
      access                     = "Allow"
      destination_address_prefix = "Storage.WestEurope"
      destination_port_range     = "53"
      direction                  = "Outbound"
      priority                   = 308
      protocol                   = "Tcp"
      source_address_prefixes    = local.subnets["aca"].address_prefixes
      source_port_range          = "*"
    }
    AllowVnetAcaOutbound = {
      name                       = "AllowVnetAcaOutbound"
      access                     = "Allow"
      destination_address_prefix = "Internet"
      destination_port_ranges    = ["443", "587", "465"]
      direction                  = "Outbound"
      priority                   = 500
      protocol                   = "Tcp"
      source_address_prefix      = "10.7.0.0/23"
      source_port_range          = "*"
    }

  }
}
