resource "azurerm_network_interface" "tier2-nics" {
  count               = "${var.count}"
  name                = "vmnic-sql-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  network_security_group_id = "${azurerm_network_security_group.tier2_fw.id}"

  ip_configuration {
    name                                    = "ipconfig${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier2.id}"]
  }
}
