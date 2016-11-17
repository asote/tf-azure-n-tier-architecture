resource "azurerm_network_interface" "tier4-nics" {
  count               = "${var.count}"
  name                = "vmnic-adds-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  network_security_group_id = "${azurerm_network_security_group.tier4_fw.id}"

  ip_configuration {
    name                          = "ipconfig${count.index +1}"
    subnet_id                     = "${azurerm_subnet.subnet4.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.4.${count.index + 5}"
  }
}
