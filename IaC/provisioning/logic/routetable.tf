resource "azurerm_route_table" "route_table" {
  name                = "${local.naming_convention}-route-table"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  route {
    name           = "route1"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }
}
