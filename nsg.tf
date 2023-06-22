# Network Security Group for master and rule
resource "azurerm_network_security_group" "mewo-master-nsg" {
  name                = "${var.prefix}-master-nsg"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  # Allow incoming connection on port 22 for SSH
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
  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Network Security Group"
    project     = "${var.project}"
  }
}

# Associate Network Security group for master with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg-master-subnet" {
  subnet_id                 = azurerm_subnet.mewo-subnet.id
  network_security_group_id = azurerm_network_security_group.mewo-master-nsg.id
}

# Network Security Group for workers and rule
resource "azurerm_network_security_group" "mewo-worker-nsg" {
  name                = "${var.prefix}-worker-nsg"
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  # Allow incoming connection on port 22 for SSH
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
  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Network Security Group"
    project     = "${var.project}"
  }
}

# Associate Network Security group for master with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg-worker)subnet" {
  subnet_id                 = azurerm_subnet.mewo-subnet.id
  network_security_group_id = azurerm_network_security_group.mewo-worker-nsg.id
}
