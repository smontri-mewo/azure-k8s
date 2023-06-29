# Virtual Machine
resource "azurerm_linux_virtual_machine" "mewo-master" {
  name                  = "${var.prefix}-master"
  location              = azurerm_resource_group.mewo-rg.location
  resource_group_name   = azurerm_resource_group.mewo-rg.name
  network_interface_ids = [azurerm_network_interface.mewo-master-nic.id]
  size               = var.vm_size
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

output "master_name" {
  value = azurerm_linux_virtual_machine.mewo-master.name
}

output "master_public_ip" {
  value = azurerm_public_ip.mewo-master-ip.ip_address
}