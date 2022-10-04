terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}

provider "azurerm" {
  features {}

}

locals {
  location_formatted = replace(lower(var.location), " ", "")
  naming_convention  = "${var.environment}-${var.service}-${local.location_formatted}"
  machine_size       = "Standard_F2"
  public_key_file      = file("../../../keys/distri.pub")
}

# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${local.naming_convention}-resource-group"
  location = var.location  
}

