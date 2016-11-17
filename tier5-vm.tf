# Create virtal machine and define image to install on VM 

resource "azurerm_virtual_machine" "tier5-vm" {
  count = "1"
  name  = "mgt-0${count.index + 1}"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.tier5-nics.*.id, count.index)}"]
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
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier5-osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier5-datadisk${count.index}.vhd"
    disk_size_gb  = "50"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "mgtvm-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"

    #    custom_data = <<EOF

    #<script>

    #  winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}

    #</script>

    #<powershell>

    #  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow

    #  $admin = [adsi]("WinNT://./administrator, user")

    #  $admin.psbase.invoke("SetPassword", "${var.admin_password}")

    #</powershell>

    #EOF
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "true"

    winrm {
      protocol = "http"
    }
  }

  #  provisioner "file" {

  #    source      = "Install-IIS.ps1"

  #    destination = "c:\\Install-IIS.ps1"

  #    connection {

  #      type     = "winrm"

  #      user     = "${var.admin_username}"

  #      password = "${var.admin_password}"

  #      timeout  = "15m"

  #    }

  #  }

  #  provisioner "remote-exec" {

  #    inline = [

  #      "powershell.exe -sta -ExecutionPolicy Unrestricted -file C:\\Install-IIS.ps1",

  #    ]

  #    connection {

  #      type     = "winrm"

  #      user     = "${var.admin_username}"

  #      password = "${var.admin_password}"

  #      timeout  = "15m"

  #    }

  #  }
}

#resource "azurerm_virtual_machine_extension" "tier2-vmext" {


#  name                 = "hostname"


#  location             = "${azurerm_resource_group.ResourceGrps.location}"


#  resource_group_name  = "${azurerm_resource_group.ResourceGrps.name}"


#  virtual_machine_name = "${element(azurerm_virtual_machine.tier2-vm.*.name, count.index)}"


#  publisher            = "Microsoft.Compute"


#  type                 = "CustomScriptExtension"


#  type_handler_version = "1.8"


#  settings = <<SETTINGS


#    {


#        "commandToExecute": "hostname"


#    }


#SETTINGS


#  tags {


#    environment = "test"


#  }


#}

