# Virtual Machine
resource "azurerm_virtual_machine" "mewo-master" {
  name                  = "${var.prefix}-master"
  location              = azurerm_resource_group.mewo-rg.location
  resource_group_name   = azurerm_resource_group.mewo-rg.name
  network_interface_ids = [azurerm_network_interface.mewo-master-nic.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-master-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mewo-master"
    admin_username = "mewo-user"
  }

  os_profile_linux_config {
    # disable_password_authentication = false
    disable_password_authentication = true
    ssh_keys {
      path = "/home/mewo-user/.ssh/authorized_keys"
      # votre clé SSH publique
      key_data = "${var.ssh_key}"
    }
  }

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "K8s master"
    project     = "${var.project}"
  }
}

# Public IPs
resource "azurerm_public_ip" "mewo-master-ip" {
  name                = "${var.prefix}-master-ip"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Master Public IP"
    project     = "${var.project}"
  }
}

# Network Interface
resource "azurerm_network_interface" "mewo-master-nic" {
  name                = "${var.prefix}-master-nic"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  ip_configuration {
    name                          = "${var.prefix}-master-ip-config"
    subnet_id                     = azurerm_subnet.mewo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mewo-master-ip.id
  }

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Network Interface"
    project     = "${var.project}"
  }
}

resource "azurerm_network_interface_security_group_association" "master" {
  # network_interface_id      = azurerm_network_interface.netif_public[count.index].id
  network_interface_id      = azurerm_network_interface.mewo-master-nic.id
  network_security_group_id = azurerm_network_security_group.mewo-master-nsg.id
}

output "public_ip" {
  value = azurerm_public_ip.mewo-master-ip.ip_address
}

output "vm_name" {
  value = azurerm_virtual_machine.mewo-master.name
}
