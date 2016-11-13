# Create virtal machine and define image to install on VM 

variable "admin_username" {}

variable "admin_password" {}

variable "count" {
  default = 2
}

resource "azurerm_virtual_machine" "vmtest" {
  count = "${var.count}"
  name  = "web-0${count.index + 1}"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.nics.*.id, count.index)}"]
  availability_set_id              = "${azurerm_availability_set.AvailabilitySets.id}"
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
    name          = "osdisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/datadisk${count.index}.vhd"
    disk_size_gb  = "250"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "webvm-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "false"

    winrm {
      protocol = "http"
    }
  }
}
