resource "azurerm_storage_account" "stacc2" {
  name                = "asotwebserverstor"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  location     = "${azurerm_resource_group.ResourceGrps.location}"
  account_type = "Standard_GRS"

  tags {
    environment = "test"
  }
}

resource "azurerm_storage_container" "blob1" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.ResourceGrps.name}"
  storage_account_name  = "${azurerm_storage_account.stacc2.name}"
  container_access_type = "private"
}
