resource "azurerm_public_ip" "lbIP" {
  name                         = "LBPublicIP"
  location                     = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb" "LB" {
  name                = "WebLoadBalancer"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lbIP.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.LB.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "Rules" {
  location                       = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.LB.id}"
  name                           = "RDP_Access"
  protocol                       = "tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}
