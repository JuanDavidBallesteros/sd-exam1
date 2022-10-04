
resource "azurerm_public_ip" "vpn_public_ip" {
  name                = "${local.naming_convention}-vpn-public-ip"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vpn_nic" {
  name                = "${local.naming_convention}-vpn-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.vpn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vpn_vm" {
  name                            = "${local.naming_convention}-vpn-vm"
  resource_group_name             = azurerm_resource_group.resource_group.name
  location                        = azurerm_resource_group.resource_group.location
  size                            = local.machine_size
  admin_username                  = var.vm_user
  #admin_password                  = "#S3rv3r"
  #disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vpn_nic.id,
  ]

  admin_ssh_key {
  username   = var.vm_user
  public_key = local.public_key_file
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

## Security Group
resource "azurerm_network_security_group" "secGroup" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges     = ["22","443","80","15206"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

resource "azurerm_network_interface_security_group_association" "secAsso" {
  network_interface_id      = azurerm_network_interface.vpn_nic.id
  network_security_group_id = azurerm_network_security_group.secGroup.id
}
