provider "azurerm" {
    version = "2.2.0"
    features{}
}

resource "azurerm_resource_group" "web_server_rg" {
    name = var.web_server_rg
    location = var.web_server_location
}

resource "azurerm_virtual_network" "web_server_vnet" {
    name = "${var.resource_prefix}-vnet"
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.web_server_rg.name
    address_space = [var.web_server_address_space]
}

resource "azurerm_subnet" "web_server_subnet" {
    name = "${var.resource_prefix}-subnet"
    resource_group_name = azurerm_resource_group.web_server_rg.name
    virtual_network_name = azurerm_virtual_network.web_server_vnet.name
    address_prefix = var.web_server_address_prefix
}

resource "azurerm_network_interface" "web_server_nic" {
    name = "${var.resource_prefix}-nic"
    resource_group_name = azurerm_resource_group.web_server_rg.name
    location = var.web_server_location

    ip_configuration {
      name = "${var.web_server_name}-ip"
      subnet_id = azurerm_subnet.web_server_subnet.id
      private_ip_address_allocation = "dynamic"
      public_ip_address_id = azurerm_public_ip.web_server_public_ip.id
    }
}

resource "azurerm_public_ip" "web_server_public_ip" {
    name = "${var.resource_prefix}-public-ip"   
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.web_server_rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "web_server_nsg" {
    name = "${var.resource_prefix}-sg"
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.web_server_rg.name
}

resource "azurerm_network_security_rule" "web_server_nsg_rule_ssh" {
  name = "${var.resource_prefix}-ssh"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.web_server_rg.name
  network_security_group_name = azurerm_network_security_group.web_server_nsg.name
}

resource "azurerm_network_interface_security_group_association" "web_server_nsg_association" {
    network_security_group_id= azurerm_network_security_group.web_server_nsg.id
    network_interface_id = azurerm_network_interface.web_server_nic.id 
}

resource "azurerm_linux_virtual_machine" "ansible_controller" {
  name = "${var.web_server_name}-controller"
  location = var.web_server_location
  resource_group_name = azurerm_resource_group.web_server_rg.name 
  network_interface_ids = [azurerm_network_interface.web_server_nic.id]
  size = "Standard_B1s"
  admin_username = "ansible-controller"
  admin_password = "iamStan4life"
  computer_name = "ubuntuVM"
  disable_password_authentication = false

  os_disk {
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

  source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}

