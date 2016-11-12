variable "admin_username" {}

variable "admin_password" {}

variable "count" {
  default = 1
}

resource "azurerm_virtual_machine" "jumphost" {
  count = "${var.count}"
  name  = "bastion-0${count.index + 1}"

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
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/bastionosdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/bastiondatadisk${count.index}.vhd"
    disk_size_gb  = "10"
    create_option = "empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "bastion-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "false"
  }
}

resource "azurerm_network_interface" "bastionnics" {
  count               = "${var.count}"
  name                = "vmnic-bastion-0${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  #network_security_group_id = "${azurerm_network_security_group.web_fw.id}"

  ip_configuration {
    name                          = "ipconfig${count.index +1}"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP.id}"
  }
}

resource "azurerm_public_ip" "PublicIP" {
  name                         = "BastionPublicIP"
  location                     = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  public_ip_address_allocation = "static"
}
