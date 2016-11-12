resource "azurerm_network_interface" "nics" {
  count               = "${var.count}"
  name                = "vmnic-web-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  network_security_group_id = "${azurerm_network_security_group.web_fw.id}"

  ip_configuration {
    name                                    = "ipconfig${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.web.id}"]
  }
}

resource "azurerm_network_security_group" "web_fw" {
  name                = "nsg_web"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  security_rule {
    name                       = "allow-rdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
