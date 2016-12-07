# Create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  dns_servers         = ["168.63.129.16"]
}

# Create subnets
resource "azurerm_subnet" "subnet1" {
  name                      = "web_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.1.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier1_fw.id}"
}

resource "azurerm_subnet" "subnet2" {
  name                      = "business_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier2_fw.id}"
}

resource "azurerm_subnet" "subnet3" {
  name                      = "data_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.3.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"
}

resource "azurerm_subnet" "subnet4" {
  name                      = "ADDS_net"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.4.0/27"
  network_security_group_id = "${azurerm_network_security_group.tier4_fw.id}"
}

resource "azurerm_subnet" "subnet5" {
  name                      = "management_net"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "10.0.0.128/25"
  network_security_group_id = "${azurerm_network_security_group.tier5_fw.id}"
}
