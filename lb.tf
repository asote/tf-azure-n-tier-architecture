resource "azurerm_public_ip" "lbIP" {
  name                         = "PublicIPForLB"
  location                     = "centralus"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_lb" "LB" {
  name                = "FELoadBalancer"
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lbIP.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.LB.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "RDP" {
  location                       = "centralus"
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.LB.id}"
  name                           = "RDP Access"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_nat_pool" "http" {
  location                       = "centralus"
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.LB.id}"
  name                           = "SampleApplication Pool"
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 81
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "tcp" {
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.LB.id}"
  name                = "tcp_probe"
  protocol            = "tcp"
  port                = 80
}
