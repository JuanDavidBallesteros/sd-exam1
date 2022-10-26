resource "azurerm_network_interface" "vm_i" {
  name                = "${local.naming_convention}-vm_nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_availability_set" "server_availability" {
  name                = "${local.naming_convention}-server-avs"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${local.naming_convention}-vm"
  resource_group_name             = azurerm_resource_group.resource_group.name
  location                        = azurerm_resource_group.resource_group.location
  size                            = local.machine_size
  admin_username                  = var.vm_user
  #admin_password                  = "#S3rv3r"
  availability_set_id             = azurerm_availability_set.server_availability.id
 # disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm_i.id,
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
resource "azurerm_network_security_group" "segGroupCore" {
  name                = "acceptanceTestSecurityGroup2"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges     = ["5000","2701","80","3000"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

resource "azurerm_network_interface_security_group_association" "secCore" {
  network_interface_id      = azurerm_network_interface.vm_i.id
  network_security_group_id = azurerm_network_security_group.segGroupCore.id
}




