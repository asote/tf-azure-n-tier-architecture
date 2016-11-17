resource "azurerm_virtual_machine" "fsw" {
  name = "fsw-01"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${azurerm_network_interface.fsw.id}"]
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  vm_size                          = "Standard_A2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "osdisk0"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/fsw-osdisk0.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/fsw-datadisk0.vhd"
    disk_size_gb  = "50"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "fsw-01"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "false"
  }
}

resource "azurerm_network_interface" "fsw" {
  name                      = "vmnic-fsw-01"
  location                  = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.subnet3.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.100"
  }
}
