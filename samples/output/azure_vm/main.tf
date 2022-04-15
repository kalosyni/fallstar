resource "azurerm_resource_group" "default" {
  name     = "rg-suseapril22-staging-westeur"
  location = "westeurope"
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

resource "azurerm_lb" "default" {
  name                = "lb-vmsuse"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  frontend_ip_configuration {
    name                 = "ipc-vmsuse-front"
    public_ip_address_id = azurerm_public_ip.default.id
  }
}

resource "azurerm_lb_backend_address_pool" "default" {
  loadbalancer_id = azurerm_lb.default.id
  name            = "bap-vmsuse"
}

resource "azurerm_network_interface" "default" {
  count               = 2
  name                = "inetvmsuse${count.index}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "ipc-vmsuse"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "default" {
  count                = 2
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
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "default" {
  count                 = 2
  name                  = "vm-vmsuse-${count.index}"
  location              = azurerm_resource_group.default.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size               = "Standard_D2as_v5"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "SUSE"
    offer     = "sles-sap-15-sp2"
    sku       = "gen2"
    version   = "latest"
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
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
