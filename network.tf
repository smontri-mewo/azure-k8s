# Resource Group
resource "azurerm_resource_group" "mewo-rg" {
  name     = "${var.prefix}-rg"
  location = "East US"

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Resource Group"
    project     = "${var.project}"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "mewo-vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mewo-rg.location
  resource_group_name = azurerm_resource_group.mewo-rg.name

  tags = {
    environment = "${var.environment}"
    owner       = "${var.prefix}"
    label       = "Virtual Network"
    project     = "${var.project}"
  }
}

# Subnet
resource "azurerm_subnet" "mewo-subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.mewo-rg.name
  virtual_network_name = azurerm_virtual_network.mewo-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Subnet
/* resource "azurerm_subnet" "mewo-subnet2" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.mewo-rg.name
  virtual_network_name = azurerm_virtual_network.mewo-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
} */