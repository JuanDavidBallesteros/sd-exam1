resource "azurerm_virtual_network" "vnet" {
  name                = "${local.naming_convention}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet server
resource "azurerm_subnet" "server_subnet" {
  name                 = "${local.naming_convention}-server_snet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet bastion
resource "azurerm_subnet" "vpn_subnet" {
  name                 = "${local.naming_convention}-vpn_snet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


