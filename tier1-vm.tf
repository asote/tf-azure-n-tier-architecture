# Create virtal machine and define image to install on VM 

resource "azurerm_virtual_machine" "tier1-vm" {
  count = "3"
  name  = "web-0${count.index + 1}"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.tier1-nics.*.id, count.index)}"]
  availability_set_id              = "${azurerm_availability_set.tier1-AvailabilitySet.id}"
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
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier1-osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk${count.index}"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier1-datadisk${count.index}.vhd"
    disk_size_gb  = "50"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "webvm-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"

    custom_data = "${base64encode(

    <<EOF

    <script>

    winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}

    </script>

    <powershell>

    netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow

    $admin = [adsi]("WinNT://./administrator, user")

    $admin.psbase.invoke("SetPassword", "${var.admin_password}")

    </powershell>

    EOF
    )}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "true"

    winrm {
      protocol = "http"

      #certificate_url = ""
    }

    #additional_unattend_config {


    #  pass         = "oobeSystem"


    #  component    = "Microsoft-Windows-Shell-Setup"


    #  setting_name = "AutoLogon"


    #  content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"


    #}


    #Unattend config is to enable basic auth in WinRM, required for the provisioner stage.


    #additional_unattend_config {


    #  pass         = "oobeSystem"


    #  component    = "Microsoft-Windows-Shell-Setup"


    #  setting_name = "FirstLogonCommands"


    #  content      = "${file("FirstLogonCommands.xml")}"


    #}

    provisioner "file" {
      source      = "Install-IIS.PS1"
      destination = "C:\\Scripts\\Install-IIS.PS1"

      connection {
        type     = "winrm"
        https    = false
        insecure = true
        user     = "${var.admin_username}"
        password = "${var.admin_password}"

        #host     = "${null_resource.intermediates.triggers.full_vm_dns_name}"

        #port     = "5985"
      }
    }
    provisioner "remote-exec" {
      inline = [
        "powershell.exe -sta -ExecutionPolicy Unrestricted -file C:\\Scripts\\Install-IIS.ps1",
      ]

      connection {
        type  = "winrm"
        https = false

        #insecure = true
        user     = "${var.admin_username}"
        password = "${var.admin_password}"

        #host     = "${null_resource.intermediates.triggers.full_vm_dns_name}"

        #port     = "5985"
      }
    }
  }
}
