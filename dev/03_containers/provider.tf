terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.36.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  resource_providers_to_register = ["Microsoft.Storage", "Microsoft.Network", "Microsoft.ContainerRegistry", "Microsoft.KeyVault"]
  features {}
}
