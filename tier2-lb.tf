# Front End Load Balancer
resource "azurerm_lb" "tier2-LB" {
  name                = "tier2-LoadBalancer"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

# Back End Address Pool
resource "azurerm_lb_backend_address_pool" "tier2" {
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier2-LB.id}"
  name                = "BackEndAddressPool"
}

# Load Balancer Rule
resource "azurerm_lb_rule" "tier2-LBRule" {
  location                       = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier2-LB.id}"
  name                           = "SQLRule"
  protocol                       = "Tcp"
  frontend_port                  = 1433
  backend_port                   = 1433
  frontend_ip_configuration_name = "PrivateIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier2.id}"
  probe_id                       = "${azurerm_lb_probe.tier2-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier2-LBProbe"]
}

resource "azurerm_lb_probe" "tier2-LBProbe" {
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier2-LB.id}"
  name                = "SQL"
  port                = 1433
}
