resource "azurerm_lb" "load_balancer" {
  name                = "${local.naming_convention}-lb"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicIP_lb.id
  }
}

## IP Load balancer
resource "azurerm_public_ip" "publicIP_lb" {
  name                = "${local.naming_convention}-lb-IP"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
  domain_name_label   = "lbipexamn1"
}

resource "azurerm_lb_backend_address_pool" "backend_pool_lb" {
  name            = "BackEndAddressPool"
  loadbalancer_id = azurerm_lb.load_balancer.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_association" {
  network_interface_id    = azurerm_network_interface.vm_i.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool_lb.id
}

resource "azurerm_lb_nat_rule" "nat_rule" {
  resource_group_name            = azurerm_resource_group.resource_group.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 3000
  frontend_ip_configuration_name = "PublicIPAddress"
  #backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool_lb.id
}

resource "azurerm_network_interface_nat_rule_association" "nat_rule_association" {
  network_interface_id  = azurerm_network_interface.vm_i.id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.nat_rule.id
}