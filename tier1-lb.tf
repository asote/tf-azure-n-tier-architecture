# VIP address
resource "azurerm_public_ip" "lbIP" {
  name                         = "LBPublicIP"
  location                     = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  public_ip_address_allocation = "static"
}

# Front End Load Balancer
resource "azurerm_lb" "tier1-LB" {
  name                = "tier1-LoadBalancer"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lbIP.id}"
  }
}

# Back End Address Pool
resource "azurerm_lb_backend_address_pool" "tier1" {
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier1-LB.id}"
  name                = "BackEndAddressPool"
}

# Load Balancer Rule
resource "azurerm_lb_rule" "tier1-LBRule" {
  location                       = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier1-LB.id}"
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier1.id}"
  probe_id                       = "${azurerm_lb_probe.tier1-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier1-LBProbe"]
}

resource "azurerm_lb_probe" "tier1-LBProbe" {
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier1-LB.id}"
  name                = "HTTP"
  port                = 80
}
