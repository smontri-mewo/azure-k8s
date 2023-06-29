########################################################################
##### WORKER 1
########################################################################

# Virtual Machine
resource "azurerm_linux_virtual_machine" "mewo-worker1" {
  name                  = "${var.prefix}-worker1"
  location              = azurerm_resource_group.mewo-rg.location
  resource_group_name   = azurerm_resource_group.mewo-rg.name
  network_interface_ids = [azurerm_network_interface.mewo-worker1-nic.id]
  size                  = var.vm_size
  admin_username        = "mewo-user"
  computer_name         = "mewo-master"  

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username = "mewo-user"
    public_key = "${var.ssh_key}"
  }

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "K8s worker1"
    project     = "${var.project}"
  }
}

# Public IPs
resource "azurerm_public_ip" "mewo-worker1-ip" {
  name                = "${var.prefix}-worker1-ip"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "worker1 Public IP"
    project     = "${var.project}"
  }
}

# Network Interface
resource "azurerm_network_interface" "mewo-worker1-nic" {
  name                = "${var.prefix}-worker1-nic"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  ip_configuration {
    name                          = "${var.prefix}-worker1-ip-config"
    subnet_id                     = azurerm_subnet.mewo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mewo-worker1-ip.id
  }

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Network Interface"
    project     = "${var.project}"
  }
}

resource "azurerm_network_interface_security_group_association" "worker1" {
  # network_interface_id      = azurerm_network_interface.netif_public[count.index].id
  network_interface_id      = azurerm_network_interface.mewo-worker1-nic.id
  network_security_group_id = azurerm_network_security_group.mewo-master-nsg.id
}


output "worker1_public_ip" {
  value = azurerm_public_ip.mewo-worker1-ip.ip_address
}

output "worker1_name" {
  value = azurerm_linux_virtual_machine.mewo-worker1.name
}

########################################################################
##### WORKER 2
########################################################################

# Virtual Machine
/* resource "azurerm_virtual_machine" "mewo-worker2" {
  name                  = "${var.prefix}-worker2"
  location              = azurerm_resource_group.mewo-rg.location
  resource_group_name   = azurerm_resource_group.mewo-rg.name
  network_interface_ids = [azurerm_network_interface.mewo-worker2-nic.id]
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
    name              = "${var.prefix}-worker2-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mewo-worker2"
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
    label       = "K8s worker2"
    project     = "${var.project}"
  }
}

# Public IPs
resource "azurerm_public_ip" "mewo-worker2-ip" {
  name                = "${var.prefix}-worker2-ip"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Worker2 Public IP"
    project     = "${var.project}"
  }
}

# Network Interface
resource "azurerm_network_interface" "mewo-worker2-nic" {
  name                = "${var.prefix}-worker2-nic"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  ip_configuration {
    name                          = "${var.prefix}-worker2-ip-config"
    subnet_id                     = azurerm_subnet.mewo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mewo-worker2-ip.id
  }

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Network Interface"
    project     = "${var.project}"
  }
}

resource "azurerm_network_interface_security_group_association" "worker2" {
  # network_interface_id      = azurerm_network_interface.netif_public[count.index].id
  network_interface_id      = azurerm_network_interface.mewo-worker2-nic.id
  network_security_group_id = azurerm_network_security_group.mewo-worker-nsg.id
}


output "worker2_public_ip" {
  value = azurerm_public_ip.mewo-worker2-ip.ip_address
}

output "worker2_name" {
  value = azurerm_virtual_machine.mewo-worker2.name
}
 */