resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-vmsuse"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "default" {
  name                 = "snet-vmsuse"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "default" {
  name                = "ip-vmsuse"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "default" {
  name                = "nsg-vmuse"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "default" {
  count               = 1
  name                = "inetvmsuse${count.index}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "ipc-vmsuse"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.default.0.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_managed_disk" "default" {
  count                = 1
  name                 = "disk-vmsuse-${count.index}"
  location             = azurerm_resource_group.default.location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
  name                         = "avset-vmsuse"
  location                     = azurerm_resource_group.default.location
  resource_group_name          = azurerm_resource_group.default.name
  platform_fault_domain_count  = 1
  platform_update_domain_count = 1
  managed                      = true
}

resource "azurerm_virtual_machine" "default" {
  count                 = 1
  name                  = "vm-vmsuse-${count.index}"
  location              = azurerm_resource_group.default.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  storage_os_disk {
    name              = "stovmsuse${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "dskvmsuse${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.default.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.default.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.default.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
