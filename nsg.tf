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

  # Allow incoming connection on port 6443 for Kube API server
  security_rule {
    name                       = "KubeAPI"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow incoming connection for etcd API
  security_rule {
    name                       = "etcd"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2379-2380"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow incoming connection for Kubelet API
  security_rule {
    name                       = "kubelet"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10250"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow incoming connection for kube-scheduler
  security_rule {
    name                       = "scheduler"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10259"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow incoming connection for kube-controller-manager
  security_rule {
    name                       = "controller"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10257"
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
/* resource "azurerm_subnet_network_security_group_association" "nsg-master-subnet" {
  subnet_id                 = azurerm_subnet.mewo-subnet1.id
  network_security_group_id = azurerm_network_security_group.mewo-master-nsg.id
} */

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

  # Allow incoming connection for Kubelet API
  security_rule {
    name                       = "etcd"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10250"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow incoming connection on port 30000-32767 for Niodeport Services
  security_rule {
    name                       = "nodeport"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32767"
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
/* resource "azurerm_subnet_network_security_group_association" "nsg-worker-subnet" {
  subnet_id                 = azurerm_subnet.mewo-subnet2.id
  network_security_group_id = azurerm_network_security_group.mewo-worker-nsg.id
} */
