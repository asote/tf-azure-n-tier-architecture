resource "azurerm_network_interface" "nics" {
  name                = "publicnic"
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  ip_configuration {
    name                          = "lbconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"

    #public_ip_address_id          = "${azurerm_public_ip.lbIP.id}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.web.id}"]
    
  }
}
